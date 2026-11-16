#!/usr/bin/env python3
"""aquarius_bitmap.py: the Aquarius character set as ONE bitmap, for iGame3D XT.

    python3 -I aquarius_bitmap.py [--hex]

Writes ../Data/Text/Aquarius.pbm: a plain (P1) PBM, 128 x 128 pixels, 16 x 16 glyphs of 8 x 8,
glyph n at column n mod 16, row n div 16. Any text editor or paint program opens it; the editor
builds its 256 Aquarius models from it (Library > Text).
--hex prints the same bitmap as 128 lines of 32 hex digits, for kAquaHex in the editor script
(its built-in copy, used when the file isn't there).

Source: glyphs 1-255 from the 2008 converter the owner wrote (iGame3D_Aquarius_Chars/Data/
Scripts/Convert/AquariusCharactersPMB.lua), glyph 0 from LIB_BIT/editor/fonts/Aquarius.font.txt.
The two agree on 251 glyphs; LIB_BIT lacks the descenders of g (103) and j (106), and 138 and 148
differ by one pixel each (the 2008 version is kept).
"""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
P = os.path.expanduser("~/projects")
LUA = os.path.join(P, "LIB_GAMES/iGame3d_To_Recreate/Later/iGame3D_Aquarius_Chars/Data/Scripts/Convert/AquariusCharactersPMB.lua")
FONT = os.path.join(P, "LIB_BIT/editor/fonts/Aquarius.font.txt")
OUT = os.path.join(os.path.dirname(HERE), "Data", "Text", "Aquarius.pbm")

g = {int(k): [r.strip() for r in v.strip().split("\n")]
     for k, v in re.findall(r"chr\[(\d+)\]=\[\[(.*?)\]\]", open(LUA).read(), re.S)}
for line in open(FONT):
    p = line.rstrip("\n").split("\t")
    if len(p) == 2 and p[0] == "0":
        rows = [int(x) for x in p[1].split(",")]
        g[0] = ["".join("1" if rows[r * 2] & (1 << (c * 2)) else "0" for c in range(8)) for r in range(8)]
assert sorted(g) == list(range(256)) and all(len(r) == 8 for v in g.values() for r in v)
bits = [["0"] * 128 for _ in range(128)]
for n, rows in g.items():
    for r, row in enumerate(rows):
        for c, b in enumerate(row):
            bits[(n // 16) * 8 + r][(n % 16) * 8 + c] = b
lines = ["".join(r) for r in bits]
if "--hex" in sys.argv:
    print("\n".join("%032X" % int(l, 2) for l in lines))
else:
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", newline="\n") as f:
        f.write("P1\n# Aquarius character set: 16 x 16 glyphs of 8 x 8, glyph n at column n mod 16, row n div 16\n"
                "# iGame3D XT builds its 256 Aquarius models from this file (Library > Text)\n128 128\n")
        f.write("\n".join(lines) + "\n")
    print("wrote", OUT, os.path.getsize(OUT), "bytes")
