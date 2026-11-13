#!/usr/bin/env python3
"""check_drafts.py - check Spark's drafts against the real source files.

    python3 -I _manifest/tools/check_drafts.py            -> _manifest/REVIEW.md

For each finished draft in _manifest/spark/ (file notes and _FOLDER.md):
  - every `backticked` name and every name in a **Provides:** line must occur in the source
    (for a folder: in any file of that folder). Names that do not are listed as UNSEEN:
    usually something Spark invented or misspelled.
  - functions the source defines but the draft never mentions are listed as MISSED.
  - the Keep / port / drop (or Verdict) line is collected.
  - names that are not in this source but are in another Data/ script are listed as ELSEWHERE
    (engine-wide globals such as gObjects, IG3D_POSITION): real, not invented, and not counted
    against the draft. File names (x.lua, x.wtf) are not checked.
  - a draft whose last line stops mid-sentence is noted as cut off (Spark ran out of tokens).
  - SELF-TALK: Spark argued with the prompt in its answer ("Wait, the instructions say...")
    and wrote some sections twice; move the draft aside and rerun.
  - PADDED: the Depends on line names prompt background (loadLevel, make, gameroot, Data/ ...)
    that this source never uses.
Lua built-ins (dofile, pairs, string.*...) and Data/ paths are not counted as engine calls,
but are noted when the draft calls a built-in an "engine call".
"""
import os, re, sys

TOOLS = os.path.dirname(os.path.abspath(__file__))
MAN = os.path.dirname(TOOLS)
ROOT = os.path.dirname(MAN)
NOTES = os.path.join(MAN, 'spark')
OUT = os.path.join(MAN, 'REVIEW.md')

LUA_BUILTINS = set('''dofile require pairs ipairs print type tostring tonumber pcall error assert
select unpack next setmetatable getmetatable rawget rawset loadstring loadfile collectgarbage
string table math io os lfs coroutine debug'''.split())
DEFINE = re.compile(r'^\s*(?:code\s*\{\s*)?(?:local\s+)?function\s+([\w.:]+)|^\s*([\w.]+)\s*=\s*function\b', re.M)
TICK = re.compile(r'`([^`\n]{1,80})`')
CODELIKE = re.compile(r'[a-z][A-Z]|_|\w[.:]\w|^[A-Z0-9]{2,}_')
IDENT = re.compile(r'^[A-Za-z_][\w.:]*(\(.*\))?$')


def source_of(draft_path, text):
    m = re.search(r'of Data/(.+?) \(model', text)
    if not m:
        return None
    return os.path.join(ROOT, m.group(1))


def read(path):
    try:
        with open(path, encoding='utf-8', errors='replace') as f:
            return f.read()
    except OSError:
        return ''


def folder_source(folder):
    parts = []
    for name in sorted(os.listdir(folder)):
        p = os.path.join(folder, name)
        if os.path.isfile(p) and not name.startswith('.'):
            parts.append(read(p))
    return '\n'.join(parts)


def names_in(text):
    """identifiers the draft claims: backticked names plus the Provides line"""
    found = set()
    for t in TICK.findall(text):
        t = t.strip()
        if '/' in t or ' ' in t.strip('()') or not IDENT.match(t):
            continue                      # paths, phrases, code fragments
        t = re.sub(r'\(.*\)$', '', t)
        if t.endswith('*') or t.endswith('_'):
            continue                      # IG3D_* style families
        found.add(t)
    m = re.search(r'\*\*Provides:\*\*(.*)', text)
    if m:
        for t in re.findall(r'[A-Za-z_][\w.:]+', m.group(1)):
            if CODELIKE.search(t):
                found.add(t)
    return found


_corpus = None
FILE_EXT = re.compile(r'\.(lua|wtf|wif|bvh|png|jpg|emt|txt|fl|pbm|xpm|obj)$', re.I)


def corpus_words():
    """every identifier in every Data/ script (not _manifest)"""
    global _corpus
    if _corpus is None:
        _corpus = set()
        for dirpath, dirs, files in os.walk(ROOT):
            dirs[:] = [d for d in dirs if d != '_manifest']
            for f in files:
                if f.endswith('.lua'):
                    _corpus.update(re.findall(r'[A-Za-z_]\w*', read(os.path.join(dirpath, f))))
    return _corpus


SELF_TALK = re.compile(r'^(?:Wait[,.]|Hmm|Let me |Let\'s |But the (?:instruction|rule)|The (?:instructions|rules) say)', re.M)
BACKGROUND = {'loadLevel': r'\bloadLevel\b', 'make': r'\bmake\s*\(', 'get': r'\bget\s*\(', 'dofile': r'\bdofile\b',
              'gameroot': r'\bgameroot\b', 'Data/': r'Data/', 'load script.lua': r'load script',
              'gObjects': r'\bgObjects\b', 'IG3D_POSITION': r'IG3D_POSITION', 'ig3d_object': r'ig3d_object'}


def padded(text, src):
    m = re.search(r'\*\*Depends on:\*\*(.*)', text)
    if not m:
        return []
    line = re.sub(r'\b(?:no|not|nothing|none|without)\b[^,;.]*', '', m.group(1), flags=re.I)  # "no `Data/` paths"
    return [k for k, rx in BACKGROUND.items()
            if re.search(r'(?<![\w/])' + re.escape(k) + r'(?![\w])', line) and not re.search(rx, src)]


def cut_off(text):
    last = [l for l in text.strip().splitlines() if l.strip()][-1].rstrip()
    if re.match(r'^\s*-\s*\*\*[^*]+:\*\*\s*\w+$', last):
        return False                      # a complete short field, e.g. "- **Procedural:** no"
    return not re.search(r'[.)`!?:*\]]$', last)


def seen(name, src):
    base = name.split('.')[-1].split(':')[-1]
    return name in src or base in src


def check(draft):
    text = read(draft)
    src_path = source_of(draft, text)
    is_folder = draft.endswith('_FOLDER.md')
    if src_path is None:
        return None
    src = folder_source(src_path) if is_folder else read(src_path)
    if not src:
        return dict(draft=draft, source=src_path, missing_source=True)
    claimed = names_in(text)
    claimed = {n for n in claimed if not FILE_EXT.search(n)}
    notlocal = sorted(n for n in claimed if n.split('.')[0] not in LUA_BIOS and not seen(n, src))
    words = corpus_words()
    elsewhere = [n for n in notlocal if n.split('.')[-1].split(':')[-1] in words]
    unseen = [n for n in notlocal if n not in elsewhere]
    defined = {a or b for a, b in DEFINE.findall(src)}
    missed = [] if is_folder else sorted(d for d in defined if d.split('.')[-1].split(':')[-1] not in text)
    builtin_as_engine = sorted(b for b in LUA_BUILTINS
                               if re.search(r'`%s`[^.\n]{0,40}engine call|engine call[^.\n]{0,40}`%s`' % (b, b), text))
    m = re.search(r'\*\*(?:Keep / port / drop|Keep|Verdict):\*\*\s*(\w+)', text)
    return dict(draft=draft, source=src_path, folder=is_folder, unseen=unseen, missed=missed, elsewhere=elsewhere,
                cut=cut_off(text), talk=bool(SELF_TALK.search(text)), padded=[] if is_folder else padded(text, src),
                defined=len(defined), builtin=builtin_as_engine, verdict=m.group(1) if m else '?')


LUA_BIOS = LUA_BUILTINS


def main():
    if len(sys.argv) > 1:
        print(__doc__)
        return
    rows = []
    for dirpath, _, files in os.walk(NOTES):
        for f in files:
            if f.endswith('.md') and not f.endswith('.spark.md'):
                r = check(os.path.join(dirpath, f))
                if r:
                    rows.append(r)
    rows.sort(key=lambda r: r['draft'])
    clean = [r for r in rows if not r.get('missing_source') and not r['unseen'] and not r['missed'] and not r['builtin']
             and not r['cut'] and not r['talk']]
    out = ['# Review of Spark drafts (generated by tools/check_drafts.py)', '',
           '%d drafts checked; %d clean (every name found in the source, no function missed).' % (len(rows), len(clean)),
           'UNSEEN = named in the draft but not in the source (likely invented). '
           'MISSED = defined in the source, never mentioned in the draft. '
           'ELSEWHERE = not in this source but defined/used in another Data/ script (real, not counted).', '',
           '| Draft | Verdict | Unseen | Missed | Elsewhere | Notes |', '|---|---|---|---|---|---|']
    for r in rows:
        rel = os.path.relpath(r['draft'], NOTES)
        if r.get('missing_source'):
            out.append('| %s | | | | | source not found |' % rel)
            continue
        notes = ['built-in called engine call: ' + ', '.join(r['builtin'])] if r['builtin'] else []
        if r['cut']:
            notes.append('**cut off** (ran out of tokens; delete and rerun)')
        if r['talk']:
            notes.append('**self-talk** (argued with the prompt; move aside and rerun)')
        if r['padded']:
            notes.append('padded Depends on: ' + ', '.join(r['padded']))
        notes = '; '.join(notes)
        out.append('| %s | %s | %s | %s | %s | %s |' % (
            rel, r['verdict'], ', '.join('`%s`' % n for n in r['unseen']) or '-',
            ('%d of %d: ' % (len(r['missed']), r['defined']) + ', '.join(r['missed'][:8]) + (' ...' if len(r['missed']) > 8 else '')) if r['missed'] else '-',
            ', '.join(r['elsewhere'][:6]) + (' ...' if len(r['elsewhere']) > 6 else '') if r['elsewhere'] else '-',
            notes))
    with open(OUT, 'w', encoding='utf-8') as f:
        f.write('\n'.join(out) + '\n')
    print('%d drafts, %d clean -> %s' % (len(rows), len(clean), OUT))


if __name__ == '__main__':
    sys.exit(main())
