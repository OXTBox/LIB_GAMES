#!/usr/bin/env python3
"""spark_manifest.py - Spark's first-look manifest of every code file in the iGame3D 2008 Data folder.

    python3 -I _manifest/tools/spark_manifest.py --plan              what would be sent (no LLM)
    python3 -I _manifest/tools/spark_manifest.py --folder Levels/HelloWorld   one folder (try this first)
    python3 -I _manifest/tools/spark_manifest.py --folder Scripts    a folder and everything under it
    python3 -I _manifest/tools/spark_manifest.py                     everything (resumable: skips done files)
    options: --model spark-x2.6-4b  --max-lines 80  --pause 3  --effort none  --force  --no-folder-notes

Per code file: split into parts at function boundaries, one PART request each, then one FILE
request over Spark's own part notes -> _manifest/spark/<folder>/<file>.md
Per folder: one FOLDER request over the file notes -> _manifest/spark/<folder>/_FOLDER.md
Data files (.wtf .obj .mtl .png .html ...) are listed in the folder request but never sent
(WTF models are catalogued by wtf_index.py instead). The .emt files of a folder are sent
together as one pseudo-file "_emitters". LM Studio must be running with the model loaded
(port 1234), reached through Windows' curl.exe as in xtalk_py/tools/spark_catalogue.py.
One request at a time, capped answers, a pause between requests.
"""
import argparse, json, os, re, subprocess, sys, time

TOOLS = os.path.dirname(os.path.abspath(__file__))
MAN = os.path.dirname(TOOLS)
ROOT = os.path.dirname(MAN)                           # the old Data/ folder
NOTES = os.path.join(MAN, 'spark')
PROMPT = os.path.join(MAN, 'spark_manifest_prompt.md')
URL = 'http://127.0.0.1:1234/v1/chat/completions'
SKIP_DIRS = {'.svn', '_manifest'}
# .fl (FLUID) files are not sent: in murgaLua iGame3D the .lua beside each one carries the same
# UI code (the owner, 2026-11-13). They are still listed in the folder manifests.
CODE_EXT = ('.lua', '.py', '.js', '.vs', '.fs')
SHADER_NAMES = ('VertexProgram', 'FragmentProgram', 'FragmentProgram_ATI')
NOT_SENT = ('Help/', 'Scripts/LuaSocket')
# folders the owner looks at first: Spark skips them entirely (no file or folder notes)
HOLD = ()
# folders of iteration copies: Spark reads only the final version of each line (Claude's
# review, MANIFEST.md); the folder note still lists every file
ONLY = {'Fluid/Mappers': ('DungeonDraw3D8.lua', 'DungeonMapperNaked.lua', 'Mapper.lua', 'Mapper3.lua', 'Mapper5.lua')}     # reference docs (Claude reads them for the glossary); third-party LuaSocket
START = re.compile(r'^\s*(?:code\s*\{\s*)?(?:local\s+)?function\s+([\w.:]+)'
                   r'|^\s*([\w.]+)\s*=\s*function\b'
                   r'|^\s*Function\s*\{\s*(\w+)'
                   r'|^\s*Fl_Window\s+(\w+)'
                   r'|^\s*def\s+(\w+)')


def prompts():
    text = open(PROMPT, encoding='utf-8').read()
    parts = re.split(r'^## (SYSTEM|PART|FILE|FOLDER)\s*$', text, flags=re.M)
    return {parts[i]: parts[i + 1].strip() for i in range(1, len(parts) - 1, 2)}


def fill(template, **values):
    return re.sub(r'\{(\w+)\}', lambda m: str(values.get(m.group(1), m.group(0))), template)


def read_lines(path):
    raw = open(path, 'rb').read().decode('latin-1')
    return raw.replace('\r\n', '\n').replace('\r', '\n').split('\n')


def name_of(line):
    m = START.match(line)
    return next((g for g in m.groups() if g), None) if m else None


def split(lines, max_lines):
    """Parts that start at function boundaries, whole functions up to max_lines each."""
    blocks, cur = [], []
    for line in lines:
        if name_of(line) and cur:
            keep = len(cur)
            while keep > 0 and (not cur[keep - 1].strip() or cur[keep - 1].lstrip().startswith(('--', '#'))):
                keep -= 1
            if keep > 0:
                blocks.append(cur[:keep])
                cur = cur[keep:]
        cur.append(line)
    if cur:
        blocks.append(cur)
    parts, cur = [], []
    for b in blocks:
        if cur and len(cur) + len(b) > max_lines:
            parts.append(cur)
            cur = []
        if len(b) > max_lines * 2:
            parts += [b[i:i + max_lines] for i in range(0, len(b), max_lines)]
            continue
        cur += b
    if cur:
        parts.append(cur)
    return [p for p in parts if any(l.strip() for l in p)]


def kind_of(rel):
    base = os.path.basename(rel)
    if rel.startswith(NOT_SENT):
        return None
    if base.endswith(CODE_EXT) or base.split(' ')[0] in SHADER_NAMES:
        return 'shader' if base.endswith(('.vs', '.fs')) or base.split(' ')[0] in SHADER_NAMES else \
               'fluid-ui' if base.endswith('.fl') else 'code'
    if base.endswith('.txt') and rel.startswith('Levels/'):
        return 'level-command-script'
    return None


def fit(text, limit):
    """Shrink notes to about limit chars (Spark's context is 8k tokens): keep the headings, Uses
    and Does lines (the file summary's Depends on is copied from Uses), then drop Does, then cut."""
    if len(text) <= limit:
        return text
    for fields in (('**Does:**', '**Uses:**', '**Purpose:**', '**Kind:**', '**Procedural:**', '**Depends on:**'),
                   ('**Uses:**', '**Purpose:**', '**Kind:**', '**Depends on:**')):
        keep = '\n'.join(l for l in text.split('\n') if l.startswith('#') or any(f in l for f in fields))
        if len(keep) <= limit:
            return keep
    return keep[:limit] + '\n... (notes cut to fit)'


# Spark arguing with the prompt inside its answer ("Wait, the instructions say ... Let me correct")
SELF_TALK = re.compile(r"^(?:Wait[,.]|Hmm|Let me |Let's |But the (?:instruction|rule)|The (?:instructions|rules) say)", re.M)
OPENERS = re.compile(r'\b(function|do|if|repeat)\b')
CLOSERS = re.compile(r'\b(end|until)\b')


def lua_toplevel(lines):
    """For each line: True if it is Lua code outside any function (depth 0, not a function start).
    Counts blocks the Lua way: function/do/if/repeat open, end/until close (for/while open with do)."""
    flags, depth, long_comment = [], 0, False
    for line in lines:
        code = line
        if long_comment:
            if ']]' not in code:
                flags.append(False)
                continue
            code, long_comment = code.split(']]', 1)[1], False
        if '--[[' in code and ']]' not in code.split('--[[', 1)[1]:
            code, long_comment = code.split('--[[', 1)[0], True
        code = re.sub(r'--.*', '', re.sub(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|\[\[.*?\]\]', '""', code))
        flags.append(depth == 0 and bool(code.strip()) and not name_of(line))
        depth = max(0, depth + len(OPENERS.findall(code)) - len(CLOSERS.findall(code)))
    return flags


def toplevel_note(name, part, flags, here, inside=None):
    """The PART prompt's Top-level instruction, decided here instead of by Spark (it argued with the rule).
    inside = the function this part continues, when a long function was cut into several parts."""
    outside = [l.strip() for l, f in zip(part, flags) if f] if flags is not None else None
    if not here and inside and not outside:
        return ('This part is the middle or end of the long function `%s` (started in an earlier part): '
                'write ONLY one section `### %s (continued)` about what this piece does.' % (inside, inside))
    if not here:
        return 'This part has no functions: write ONLY a `### Top level` section.'
    if flags is None:      # not Lua: let Spark judge
        return ('If there is code outside any function (setup, globals, widget definitions, settings), '
                'start with a section `### Top level`.')
    if outside:
        return ('This part HAS code outside functions (%d lines, e.g. `%s`): start with a `### Top level` section.'
                % (len(outside), outside[0][:60]))
    return 'This part has NO code outside functions: do not write a `### Top level` section.'


def chat(model, system, user, max_tokens, effort):
    body = {'model': model, 'temperature': 0.2, 'max_tokens': max_tokens, 'reasoning_effort': effort,
            'messages': [{'role': 'system', 'content': system}, {'role': 'user', 'content': user}]}
    r = subprocess.run(['curl.exe', '-sS', '-m', '900', URL, '-H', 'Content-Type: application/json',
                        '--data-binary', '@-'], input=json.dumps(body).encode('utf-8'), capture_output=True)
    if r.returncode != 0:
        sys.exit('LM Studio is not answering at %s (start it and load the model): %s'
                 % (URL, r.stderr.decode(errors='replace').strip()))
    d = json.loads(r.stdout.decode('utf-8', 'replace'))
    if 'choices' not in d:
        sys.exit('LM Studio error: %s' % d)
    out = d['choices'][0]['message'].get('content') or ''
    out = re.sub(r'<think>.*?</think>', '', out, flags=re.S).strip()
    if d['choices'][0].get('finish_reason') == 'length':
        out += '\n\n<!-- CUT OFF: reached max_tokens (%d); delete this file and rerun -->' % max_tokens
    return out


def ask(model, system, user, max_tokens, effort):
    """chat, but one retry when Spark argues with the prompt in its answer; marked if it still does."""
    out = chat(model, system, user, max_tokens, effort)
    if SELF_TALK.search(out):
        print('    (self-talk in the answer; asking again)', flush=True)
        out = chat(model, system, user + '\n\nWrite the notes once, exactly in the format. No remarks about the '
                   'instructions.', max_tokens, effort)
        if SELF_TALK.search(out):
            out += '\n\n<!-- SELF-TALK: Spark argued with the prompt twice; review by hand -->'
    return out


def header_of(lines):
    out = []
    for line in lines[:40]:
        s = line.strip()
        if s.startswith(('--', '#', '//')):
            out.append(s)
        elif s:
            break
    return '\n'.join(out[:12]) or '(none)'


def folders():
    """{rel folder: (files, subfolders)} for every folder, top-down."""
    out = {}
    for d, dirs, files in os.walk(ROOT):
        dirs[:] = sorted(x for x in dirs if x not in SKIP_DIRS)
        rel = os.path.relpath(d, ROOT).replace(os.sep, '/')
        rel = '' if rel == '.' else rel
        out[rel] = (sorted(f for f in files if f != '.DS_Store' and 'Zone.Identifier' not in f), dirs[:])
    return out


def jobs_for(rel, files):
    """[(name, kind, lines)] to send for one folder."""
    jobs, emt = [], []
    for f in files:
        if rel in ONLY and f not in ONLY[rel]:
            continue
        frel = (rel + '/' + f).lstrip('/')
        path = os.path.join(ROOT, frel)
        if f.lower().endswith(('.emt', '.emt kopie')):
            emt.append('# ' + f)
            emt += read_lines(path) + ['']
            continue
        k = kind_of(frel)
        if k and os.path.getsize(path) > 0:
            jobs.append((f, k, read_lines(path)))
    if emt:
        jobs.append(('_emitters', 'emitter-settings', emt))
    return jobs


# ---- ebb and flow: work a while, then unload the model and rest, so RAM and heat come down
WORK_START = [time.time()]


def lms(*args):
    """LM Studio's command-line tool (Windows), quietly; returns its text"""
    try:
        home = subprocess.run(['cmd.exe', '/c', 'echo %USERPROFILE%'], capture_output=True, text=True,
                              cwd='/mnt/c').stdout.strip()
        exe = subprocess.run(['wslpath', home], capture_output=True, text=True).stdout.strip() + '/.cache/lm-studio/bin/lms.exe'
        r = subprocess.run([exe] + list(args), capture_output=True, text=True, cwd='/mnt/c', timeout=300)
        return re.sub(r'\x1b\[[0-9;]*m', '', r.stdout + r.stderr)
    except Exception as e:
        return str(e)


def breathe(a):
    if a.work_minutes <= 0 or time.time() - WORK_START[0] < a.work_minutes * 60:
        return
    print('  resting %d min (model unloaded, RAM freed) - %s' % (a.rest_minutes, time.strftime('%H:%M')), flush=True)
    lms('unload', a.model)
    time.sleep(a.rest_minutes * 60)
    print('  back to work - %s' % time.strftime('%H:%M'), flush=True)
    lms('load', a.model, '--identifier', a.model, '--context-length', '8192', '--parallel', '1', '--ttl', '600', '--yes')
    WORK_START[0] = time.time()


def do_file(rel, name, kind, lines, a, p):
    outdir = os.path.join(a.notes, rel)
    out = os.path.join(outdir, name + '.md')
    if os.path.exists(out) and not a.force:
        return open(out, encoding='utf-8').read().split('\n---\n')[0]
    breathe(a)
    parts = split(lines, a.max_lines)
    names = [n for n in map(name_of, lines) if n]
    flags = lua_toplevel(lines) if name.endswith('.lua') else None
    at = 0
    print('%s/%s: %d lines, %d functions, %d parts' % (rel, name, len(lines), len(names), len(parts)), flush=True)
    os.makedirs(outdir, exist_ok=True)
    notes = []
    for i, part in enumerate(parts, 1):
        here = [n for n in map(name_of, part) if n]
        ctx = 'This part is the start of the file.' if i == 1 else 'It continues from earlier parts.'
        while at < len(lines) and lines[at:at + len(part)] != part:   # parts of blank lines only were dropped
            at += 1
        pflags = flags[at:at + len(part)] if flags is not None else None
        inside = next((n for n in map(name_of, reversed(lines[:at])) if n), None) if pflags and not any(pflags) else None
        at += len(part)
        user = fill(p['PART'], file=name, folder=rel or 'Data', part=i, parts=len(parts), context=ctx,
                    names=', '.join(here) or ('(none: continues %s)' % inside if inside else '(none: top-level code only)'),
                    code='\n'.join(part), toplevel=toplevel_note(name, part, pflags, here, inside))
        print('  part %d/%d ...' % (i, len(parts)), flush=True)
        budget = min(a.max_tokens, 400 + 300 * max(1, len(here)))
        notes.append('## Part %d of %d\n\n%s' % (i, len(parts), ask(a.model, p['SYSTEM'], user, budget, a.effort)))
        with open(out + '.partial', 'w', encoding='utf-8') as f:
            f.write('\n\n'.join(notes))
        time.sleep(a.pause)
    user = fill(p['FILE'], file=name, folder=rel or 'Data', lines=len(lines), kind=kind,
                header=header_of(lines), notes=fit('\n\n'.join(notes), a.fit_chars))
    print('  file summary ...', flush=True)
    summary = ask(a.model, p['SYSTEM'], user, 1500, a.effort)
    with open(out, 'w', encoding='utf-8') as f:
        f.write('<!-- Spark first-look of Data/%s/%s (model %s, %s). DRAFT for Claude to review. -->\n\n'
                % (rel, name, a.model, time.strftime('%Y-%m-%d %H:%M')))
        f.write(summary + '\n\n---\n\n# Part notes\n\n' + '\n\n'.join(notes) + '\n')
    os.remove(out + '.partial')
    time.sleep(a.pause)
    return summary


def do_folder(rel, files, subs, a, p):
    jobs = jobs_for(rel, files)
    summaries = [do_file(rel, n, k, l, a, p) for n, k, l in jobs]
    out = os.path.join(a.notes, rel, '_FOLDER.md')
    if a.no_folder_notes or (os.path.exists(out) and not a.force) or not (files or subs):
        return
    breathe(a)
    listing = ', '.join(files) if len(files) <= 60 else ', '.join(files[:60]) + ' ... (+%d more)' % (len(files) - 60)
    user = fill(p['FOLDER'], folder='Data/' + rel if rel else 'Data', count=len(files), listing=listing or '(none)',
                subfolders=', '.join(subs) or '(none)', notes=fit('\n\n'.join(summaries), a.fit_chars) or '(no code files: data only)')
    print('%s: folder manifest ...' % (rel or 'Data'), flush=True)
    os.makedirs(os.path.dirname(out), exist_ok=True)
    # big folders need room: ~80 tokens per file line plus the other sections (2000 was cut off at 47 files)
    text = ask(a.model, p['SYSTEM'], user, max(2000, min(a.max_tokens, 1000 + 80 * len(files))), a.effort)
    with open(out, 'w', encoding='utf-8') as f:
        f.write('<!-- Spark folder manifest of Data/%s (model %s, %s). DRAFT. -->\n\n'
                % (rel, a.model, time.strftime('%Y-%m-%d %H:%M')) + text + '\n')
    time.sleep(a.pause)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--folder', default=None, help='relative folder (and everything under it), e.g. Scripts/Functions')
    ap.add_argument('--model', default='spark-x2.6-4b')
    ap.add_argument('--max-lines', type=int, default=80)
    ap.add_argument('--max-tokens', type=int, default=3500)
    ap.add_argument('--effort', default='none')
    ap.add_argument('--pause', type=float, default=3)
    ap.add_argument('--notes', default=NOTES)
    ap.add_argument('--fit-chars', type=int, default=16000, help='max chars of notes sent to a summary (8k-token context)')
    ap.add_argument('--force', action='store_true')
    ap.add_argument('--no-folder-notes', action='store_true')
    ap.add_argument('--work-minutes', type=float, default=0, help='work this long, then rest (0 = never rest)')
    ap.add_argument('--rest-minutes', type=float, default=15)
    ap.add_argument('--plan', action='store_true', help='list folders, files and part counts; ask nothing')
    a = ap.parse_args()
    tree = folders()
    want = [r for r in tree if a.folder is None or r == a.folder.strip('/') or r.startswith(a.folder.strip('/') + '/')]
    if not want:
        sys.exit('no such folder: %s' % a.folder)
    want = [r for r in want if not any(r == h or r.startswith(h + '/') for h in HOLD)]
    # deepest folders first, so a parent's manifest can mention finished children
    want.sort(key=lambda r: (-r.count('/'), r))
    if a.plan:
        total = 0
        for r in sorted(want):
            jobs = jobs_for(r, tree[r][0])
            n = sum(len(split(l, a.max_lines)) + 1 for _, _, l in jobs) + 1
            total += n
            print('%-40s %3d files, %2d sent, %4d requests' % (r or '(Data)', len(tree[r][0]), len(jobs), n))
        print('total requests: %d' % total)
        return
    p = prompts()
    for r in want:
        do_folder(r, *tree[r], a, p)


if __name__ == '__main__':
    main()
