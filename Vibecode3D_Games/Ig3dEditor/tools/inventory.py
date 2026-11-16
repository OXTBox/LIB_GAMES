#!/usr/bin/env python3
"""inventory.py: what the 2008 iGame3D Data folder holds, written down before it leaves the
standalone edition (the owner, 16 Nov: "inventory for procedural generation and remove").

    python3 -I inventory.py [DATA_FOLDER] [OUT_DIR]

DATA_FOLDER defaults to ~/projects/LIB_GAMES/igame3D_2008_Texts; OUT_DIR to this tool's parent.
Writes INVENTORY.tsv (one row per file: group, name, kind, vertices, edges, width, height,
depth) and INVENTORY.md (per group: the names, so a generator can be seeded from them).
.wtf (iGame3D 2007): a "#Vertices:" line, the count on the next line, then x,y,z,bone lines;
"#Edges:" the same, then a,b lines (other "#" sections: Bones, Paths, Groups, ...).
"""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
DATA = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser("~/projects/LIB_GAMES/igame3D_2008_Texts")
OUT = sys.argv[2] if len(sys.argv) > 2 else os.path.dirname(HERE)


def wtf(path):
    v, e, mode, xs, ys, zs = 0, 0, None, [], [], []
    for line in open(path, encoding="latin-1"):
        line = line.strip()
        if line.startswith("#"):
            m = re.match(r"#(Vertices|Edges)\b", line, re.I)
            mode = m.group(1).lower() if m else None
            continue
        if not line or "," not in line:          # blank, or the count line
            continue
        if mode == "vertices":
            p = re.split(r"[ ,\t]+", line)
            try:
                xs.append(float(p[0])); ys.append(float(p[1])); zs.append(float(p[2]))
                v += 1
            except (ValueError, IndexError):
                pass
        elif mode == "edges":
            e += 1
    size = [round(max(a) - min(a), 2) if a else 0 for a in (xs, ys, zs)]
    return v, e, size


rows = []
for root, _d, files in os.walk(DATA):
    if "/_manifest" in root:
        continue
    for fn in sorted(files):
        p = os.path.join(root, fn)
        rel = os.path.relpath(p, DATA)
        group = os.path.dirname(rel) or "."
        name, ext = os.path.splitext(fn)
        if ext.lower() == ".wtf":
            v, e, s = wtf(p)
            rows.append((group, name, "wtf", v, e, *s))
        else:
            rows.append((group, name, ext.lstrip(".").lower() or "-", "", "", "", "", ""))
rows.sort(key=lambda r: (r[0].lower(), r[1].lower()))
with open(os.path.join(OUT, "INVENTORY.tsv"), "w", encoding="utf-8") as f:
    f.write("group\tname\tkind\tvertices\tedges\twidth\theight\tdepth\n")
    for r in rows:
        f.write("\t".join(map(str, r)) + "\n")
groups = {}
for r in rows:
    groups.setdefault(r[0], []).append(r)
md = ["# The 2008 Data folder, inventoried\n",
      f"Made by `tools/inventory.py` from `{DATA.replace(os.path.expanduser('~'), '~')}`: "
      f"{len(rows)} files in {len(groups)} folders. Sizes per model are in `INVENTORY.tsv`. These names "
      "seed the procedural generators; the files themselves stay in `ig3d-editor-works`.\n"]
for g in sorted(groups, key=str.lower):
    rs = groups[g]
    kinds = sorted(set(r[2] for r in rs))
    md.append(f"## {g} ({len(rs)}: {', '.join(kinds)})\n")
    md[-1] += "\n" + ", ".join(r[1] for r in rs) + "\n"
with open(os.path.join(OUT, "INVENTORY.md"), "w", encoding="utf-8") as f:
    f.write("\n".join(md))
print(f"{len(rows)} files, {len(groups)} folders -> {OUT}/INVENTORY.tsv, INVENTORY.md")
