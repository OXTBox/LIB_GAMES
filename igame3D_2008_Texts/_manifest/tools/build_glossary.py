#!/usr/bin/env python3
"""build_glossary.py - LIB_ig3d/GLOSSARY.md and PROCEDURES.md from the 2008 iGame3D texts
(MANIFEST.md section 8, LIB_SYSTEM TODO A-16).

  python3 -I _manifest/tools/build_glossary.py        (run from igame3D_2008_Texts/ or anywhere)

Sources, most trusted first:
  1. Help/reference.txt and Help/scripting.txt: the engine's own `func:` / `docs:` records. These
     ARE the engine calls; the table is copied, not interpreted.
  2. Spark's drafts in _manifest/spark/ whose verdict in REVIEW.md (tools/check_drafts.py) is
     `keep`: their **Glossary** and **Procedure candidates** bullets, each with the folder it came
     from. A term already in 1 keeps the engine's own words; Spark's meaning is not used for it.
Re-run after every Spark run and check_drafts.py; the files are overwritten.
"""
import os, re, sys
from collections import OrderedDict

HERE = os.path.dirname(os.path.abspath(__file__))
TEXTS = os.path.abspath(os.path.join(HERE, '..', '..'))
SPARK = os.path.join(TEXTS, '_manifest', 'spark')
REVIEW = os.path.join(TEXTS, '_manifest', 'REVIEW.md')
OUT = os.path.abspath(os.path.join(TEXTS, '..', '..', 'LIB_ig3d'))


def engine_calls():
    calls = OrderedDict()
    for name in ('reference.txt', 'scripting.txt'):
        path = os.path.join(TEXTS, 'Help', name)
        if not os.path.exists(path):
            continue
        func = None
        for line in open(path, encoding='latin-1'):
            line = line.rstrip('\n')
            if line.startswith('func:'):
                func = line[5:].strip()
            elif line.startswith('docs:') and func:
                key = func.split('(')[0].strip()
                calls.setdefault(key, (func, line[5:].strip(), name))
                func = None
    return calls


def kept_drafts():
    keep = []
    for line in open(REVIEW, encoding='utf-8'):
        m = re.match(r'\| (.+?\.md) \| keep \|', line)
        if m:
            keep.append(m.group(1))
    return keep


def bullets(text, heading):
    """the '  - a - b' lines under '- **heading:**'"""
    out, on = [], False
    for line in text.splitlines():
        if line.startswith('- **'):
            on = line.startswith('- **%s:**' % heading)
            rest = line.split(':**', 1)[1].strip() if on else ''
            if on and rest:
                out.append(rest)
            continue
        if on and line.startswith('  - '):
            out.append(line[4:].strip())
    return out


def main():
    calls = engine_calls()
    keep = kept_drafts()
    terms = OrderedDict()            # term -> [meaning, set(folders)]
    procs = []                       # (folder, entry point, candidates text)
    for rel in keep:
        path = os.path.join(SPARK, rel)
        if not os.path.exists(path):
            continue
        text = open(path, encoding='utf-8').read()
        folder = os.path.dirname(rel)
        for b in bullets(text, 'Glossary'):
            if ' - ' not in b:
                continue
            term, meaning = b.split(' - ', 1)
            term = term.replace('`', '').strip().strip('*')
            if not term or len(term) > 60:
                continue
            rec = terms.setdefault(term, [meaning.strip(), set()])
            rec[1].add(folder)
        if os.path.basename(rel) == '_FOLDER.md':
            entry = (bullets(text, 'Entry point') or ['-'])[0]
            cand = ' '.join(bullets(text, 'Procedure candidates'))
            if cand and not cand.lower().startswith(('none', 'no ')):
                procs.append((folder, entry, cand))
    os.makedirs(OUT, exist_ok=True)

    g = ['# iGame3D glossary (2008 engine)', '',
         'Built by `LIB_GAMES/igame3D_2008_Texts/_manifest/tools/build_glossary.py`; do not edit by hand,',
         'run it again. Part 1 is the engine\'s own help text. Part 2 is from Spark\'s drafts that passed',
         '`check_drafts.py` (every name they use exists in the source); meanings there are Spark\'s',
         'reading, not checked word by word. xt3d / Vibecode3D names: to be filled as each call gets',
         'its new home (LIB_SYSTEM TODO A-16).', '',
         'Coverage: %d engine calls; %d terms from %d kept drafts (of about 2,450 planned Spark requests).'
         % (len(calls), sum(1 for t in terms if t not in calls), len(keep)), '',
         '## 1. Engine calls (Help/reference.txt, Help/scripting.txt)', '',
         '| Call | What it does (the 2008 help) | xt3d / Vibecode3D |', '|---|---|---|']
    for key, (sig, doc, src) in sorted(calls.items(), key=lambda kv: kv[0].lower()):
        g.append('| `%s` | %s | |' % (sig.replace('|', '\\|'), doc.replace('|', '\\|')))
    g += ['', '## 2. Terms from the drafts', '',
          '| Term | Meaning (Spark, checked names) | Seen in |', '|---|---|---|']
    for term, (meaning, folders) in sorted(terms.items(), key=lambda kv: kv[0].lower()):
        if term in calls or term.split('(')[0] in calls:
            continue
        where = ', '.join(sorted(folders)[:3]) + (' +%d' % (len(folders) - 3) if len(folders) > 3 else '')
        g.append('| `%s` | %s | %s |' % (term.replace('|', '\\|'), meaning.replace('|', '\\|'), where))
    open(os.path.join(OUT, 'GLOSSARY.md'), 'w').write('\n'.join(g) + '\n')

    p = ['# iGame3D procedures (2008 engine): what to rebuild as code instead of carrying files', '',
         'Built by `build_glossary.py` from the **Procedure candidates** of kept `_FOLDER.md` drafts.',
         'Status per row is for the owner and Claude to set: *procedure* (write it for xt3d/Vibecode3D),',
         '*file (glTF)* (keep the asset), *drop*. Inputs/outputs are the drafts\' words; read the source',
         'file before writing the new version.', '',
         '| Folder | Entry point | Candidates (Spark) | Status | New home |', '|---|---|---|---|---|']
    for folder, entry, cand in sorted(procs):
        p.append('| Data/%s | %s | %s | | |' % (folder, entry.replace('|', '\\|'), cand.replace('|', '\\|')))
    open(os.path.join(OUT, 'PROCEDURES.md'), 'w').write('\n'.join(p) + '\n')
    print('engine calls %d, terms %d, procedure folders %d, kept drafts %d -> %s'
          % (len(calls), len(terms), len(procs), len(keep), OUT))
    return 0


if __name__ == '__main__':
    sys.exit(main())
