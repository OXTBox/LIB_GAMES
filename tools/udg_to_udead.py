#!/usr/bin/env python3
"""udg_to_udead.py - uDeadGame 2009 (iGame3D, Lua) levels -> one text data file for the
Vibecode3D recreation (Vibecode3D_Games/uDead/udead_levels.txt).

    python3 -I tools/udg_to_udead.py            write the data file
    python3 -I tools/udg_to_udead.py --show Arcade     print one level's map and cast

For every level in the original's play order it reads `load script.lua` (the cast: who
stands where, with which model) and the level mesh (.wtf, text). The mesh is cut at body
height and pressed flat into a 1-bit grid (1 = wall), the format LIB_BIT / LIB_MAP use, so
the game builds walls with Map.BlockEdges and finds paths with Map.FindPath.
Nothing is read but text; no images.
"""
import argparse, math, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, '..', 'iGame3d_To_Recreate', 'iGame3D_uDeadGame2009-master', 'uDeadGameWin')
OUT = os.path.join(HERE, '..', 'Vibecode3D_Games', 'uDead', 'udead_levels.txt')
FIRST = 'LivingInn'
CELL = 0.5            # metres per grid cell
BAND = (0.35, 1.1)    # a triangle crossing this height band (above the floor) is a wall
MODEL_SCALE = 1 / 660.0   # level mesh units per metre (a 1320-unit wall is 2 m; fits every level's cast)
MARGIN = 6.0               # metres of level kept around the cast


def read(path):
    return open(path, encoding='latin-1').read().replace('\r\n', '\n').replace('\r', '\n')


def lua_list(text, name):
    m = re.search(r'^%s=\{(.*)\}\s*$' % name, text, flags=re.M)
    return m.group(1) if m else ''


def triples(s):
    return [tuple(float(v) for v in t.split(',')) for t in re.findall(r'\{([^{}]*)\}', s)]


def kind_of(name, wtf):
    """the original sorts objects by words in their name or model (UDG_Zombie/Human/Gun/Door/Window.lua)"""
    n, w = name.lower(), wtf.lower()
    if 'characters/' in w:
        if any(z in n[:4] for z in ('zomb',)) or any(z in w for z in ('zomb', 'slimed', 'snowed', 'ghost', 'hungry', 'alien')):
            return 'zombie'
        return 'human'
    if 'door' in n:
        return 'door'
    if 'window' in n or 'glasscube' in n:
        return 'window'
    if any(g in w for g in ('gloc', 'luger', 'deadlydisc')):
        return 'pistol'
    if 'weapons/' in w and any(g in w for g in ('rifle', 'shotgun', 'm98', 'mp40', 'hk53', 'm198', 'm16', 'lazer', 'gun')):
        return 'rifle'
    if any(g in w for g in ('baton', 'pipe', 'shovel', 'broom', 'mallet', 'halberd', 'icepick', 'bostaff', 'spear', 'sword', 'tools/')):
        return 'melee'
    if n.startswith('playerbox'):
        return 'player'
    return None


def level(name):
    folder = os.path.join(SRC, 'Data', 'Levels', 'UDG', 'UDG_' + name)
    t = read(os.path.join(folder, 'load script.lua'))
    auto, tail = t.split('-- End of auto-script', 1) if '-- End of auto-script' in t else (t, '')
    wtfs = re.findall(r'"([^"]*)"', lua_list(auto, 'gObjectWTFs'))
    names = re.findall(r'"([^"]*)"', lua_list(auto, 'gObjectNames'))
    pos = triples(lua_list(auto, 'gObjectPositions'))
    rot = triples(lua_list(auto, 'gObjectRotations'))
    cast = []
    for i, n in enumerate(names):
        k = kind_of(n, wtfs[i])
        if k:
            cast.append(dict(kind=k, name=n, model=os.path.basename(wtfs[i]).replace('.wtf', ''),
                             x=pos[i][0], y=pos[i][1], z=pos[i][2], ry=rot[i][1]))
    nxt = re.findall(r'gNumHumans==0 then\s*return "Data/Levels/UDG/UDG_(\w+)"\s*,\s*"((?:[^"\\]|\\.)*)"', tail)
    lose = re.findall(r'gNumZombies==0 then\s*return [^,]*,\s*"((?:[^"\\]|\\.)*)"', tail)
    mesh = re.search(r'loadMesh\("([^"]+)"\)', auto).group(1)
    calls = sorted(set(re.findall(r'^\s*(udg_(?:sniper|gauntlet|SnipersAlley)\w*)\(\)', tail, flags=re.M)))
    return dict(name=name, cast=cast, next=nxt[0][0] if nxt else 'MainMenu',
                win=nxt[0][1] if nxt else '', lose=lose[0] if lose else '',
                mesh=os.path.join(SRC, mesh), hard=name.endswith('Hard'), calls=calls,
                grid_size=(re.findall(r'gGridSize=(\d+)', tail) or ['1'])[0])


def triangles(path):
    """[(a,b,c)] of (x,y,z) in metres from an 'iGame3D Mdl' text model"""
    L = read(path).split('\n')
    i = L.index('#Vertices:')
    n = int(L[i + 1])
    V = [tuple(float(v) * MODEL_SCALE for v in L[i + 2 + k].split(',')[:3]) for k in range(n)]
    i = L.index('#Materials:')
    count = int(L[i + 1])
    i += 2
    out = []
    for _ in range(count):
        props = int(L[i + 1])
        i += 2 + props
        nt = int(L[i])
        for k in range(nt):
            f = L[i + 1 + k].split(',')
            out.append((V[int(f[0])], V[int(f[1])], V[int(f[2])]))
        i += 1 + nt
    return out


def grid_of(tris, cast):
    """-> (rows of '0'/'1', left x, top z, floor y). 1 = something stands in the body-height band."""
    # keep the part of the level the cast stands in (the meshes run far past it), plus a margin
    people = [c for c in cast if c['kind'] in ('human', 'zombie', 'player')]
    mx = sorted(c['x'] for c in people)
    mz = sorted(c['z'] for c in people)
    medx, medz = mx[len(mx) // 2], mz[len(mz) // 2]
    near = [c for c in people if abs(c['x'] - medx) < 150 and abs(c['z'] - medz) < 150]   # drops parked strays
    left = math.floor(min(c['x'] for c in near) - MARGIN)
    right = math.ceil(max(c['x'] for c in near) + MARGIN)
    top = math.floor(min(c['z'] for c in near) - MARGIN)
    bottom = math.ceil(max(c['z'] for c in near) + MARGIN)
    cols, rows = int((right - left) / CELL) + 1, int((bottom - top) / CELL) + 1
    # the floor: the height most characters stand at, minus half a body
    ys = sorted(c['y'] for c in cast if c['kind'] in ('human', 'zombie'))
    floor = (ys[len(ys) // 2] - 0.5) if ys else 0.0
    lo, hi = floor + BAND[0], floor + BAND[1]
    g = [[0] * cols for _ in range(rows)]
    step = CELL * 0.2
    for a, b, c in tris:
        ymin, ymax = min(a[1], b[1], c[1]), max(a[1], b[1], c[1])
        if ymax < lo or ymin > hi:
            continue
        ux, uy, uz = b[0] - a[0], b[1] - a[1], b[2] - a[2]
        vx, vy, vz = c[0] - a[0], c[1] - a[1], c[2] - a[2]
        nx, ny, nz = uy * vz - uz * vy, uz * vx - ux * vz, ux * vy - uy * vx
        nl = math.sqrt(nx * nx + ny * ny + nz * nz)
        if nl == 0 or abs(ny) / nl > 0.85:          # floors, ceilings, table tops, gentle ramps
            continue
        n1 = max(1, int(math.sqrt(ux * ux + uy * uy + uz * uz) / step))
        n2 = max(1, int(math.sqrt(vx * vx + vy * vy + vz * vz) / step))
        for i in range(n1 + 1):
            s = i / n1
            for j in range(n2 + 1 - int(s * n2)):
                t = j / n2
                if s + t > 1.0001:
                    break
                y = a[1] + s * uy + t * vy
                if lo <= y <= hi:
                    cx = int((a[0] + s * ux + t * vx - left) / CELL)
                    cz = int((a[2] + s * uz + t * vz - top) / CELL)
                    if 0 <= cx < cols and 0 <= cz < rows:
                        g[cz][cx] = 1
    for r in range(rows):                      # a solid rim: nobody walks off the map
        g[r][0] = g[r][cols - 1] = 1
    for c in range(cols):
        g[0][c] = g[rows - 1][c] = 1
    return g, left, top, floor


ORDER = None


def play_order():
    """the levels in the order the original chains them (each level names the next), first to last"""
    out, name = [], FIRST
    while name != 'MainMenu' and name not in out:
        out.append(name)
        name = level(name)['next']
    return out


def open_cell(g, c, r):
    return 0 <= r < len(g) and 0 <= c < len(g[0]) and not g[r][c]


def nearest_open(g, c, r, ok=None, reach=6):
    """the open cell nearest c,r (within reach cells) that passes ok(c,r)"""
    best = None
    for d in range(0, reach + 1):
        for rr in range(r - d, r + d + 1):
            for cc in range(c - d, c + d + 1):
                if max(abs(rr - r), abs(cc - c)) == d and open_cell(g, cc, rr) and (ok is None or ok(cc, rr)):
                    k = (cc - c) ** 2 + (rr - r) ** 2
                    if best is None or k < best[0]:
                        best = (k, cc, rr)
        if best:
            return best[1], best[2]
    return None


def gap_cells(g, c, r, widest=5):
    """a door or window at open cell c,r: the cells of the gap it closes (wall to wall), or None"""
    for dc, dr in ((1, 0), (0, 1)):
        cells, ends = [(c, r)], 0
        for sgn in (1, -1):
            k = 1
            while k <= widest and open_cell(g, c + sgn * dc * k, r + sgn * dr * k):
                cells.append((c + sgn * dc * k, r + sgn * dr * k))
                k += 1
            if k <= widest:
                ends += 1
        if ends == 2 and len(cells) <= widest:
            return sorted(cells)
    return None


def flood(g, starts):
    seen, todo = set(starts), list(starts)
    while todo:
        c, r = todo.pop()
        for cc, rr in ((c + 1, r), (c - 1, r), (c, r + 1), (c, r - 1)):
            if (cc, rr) not in seen and open_cell(g, cc, rr):
                seen.add((cc, rr))
                todo.append((cc, rr))
    return seen


def wall_segments(g):
    """the outline between wall and floor as merged straight runs, in cell-corner units: (c1,r1,c2,r2)"""
    rows, cols = len(g), len(g[0])
    out = []
    for r in range(1, rows):                    # horizontal runs on the line above row r
        c = 0
        while c < cols:
            if g[r - 1][c] != g[r][c]:
                c0 = c
                while c < cols and g[r - 1][c] != g[r][c]:
                    c += 1
                out.append((c0, r, c, r))
            else:
                c += 1
    for c in range(1, cols):                    # vertical runs on the line left of column c
        r = 0
        while r < rows:
            if g[r][c - 1] != g[r][c]:
                r0 = r
                while r < rows and g[r][c - 1] != g[r][c]:
                    r += 1
                out.append((c, r0, c, r))
            else:
                r += 1
    return out


def build(name):
    """everything the game needs for one level, as a dict; notes say what was changed to make it playable"""
    lv = level(name)
    g, left, top, floor = grid_of(triangles(lv['mesh']), lv['cast'])
    cols, rows = len(g[0]), len(g)
    notes = []

    def cell(c):
        return int((c['x'] - left) / CELL), int((c['z'] - top) / CELL)

    people = [c for c in lv['cast'] if c['kind'] in ('human', 'zombie', 'player')]
    people = [c for c in people if 0 <= cell(c)[0] < cols and 0 <= cell(c)[1] < rows]
    for c in people:                            # out of the walls
        cc, rr = cell(c)
        if not open_cell(g, cc, rr):
            spot = nearest_open(g, cc, rr, reach=8)
            if spot:
                c['x'], c['z'] = left + (spot[0] + 0.5) * CELL, top + (spot[1] + 0.5) * CELL
    barriers = []
    for c in lv['cast']:
        if c['kind'] in ('door', 'window'):
            cc, rr = cell(c)
            if not (0 <= cc < cols and 0 <= rr < rows):
                continue
            spot = nearest_open(g, cc, rr, ok=lambda a, b: gap_cells(g, a, b) is not None, reach=1)
            if spot:
                cells = gap_cells(g, spot[0], spot[1])
                if not any(set(cells) & set(b['cells']) for b in barriers):
                    barriers.append(dict(kind=c['kind'], name=c['name'], cells=cells))
    # every human must be reachable by the dead (doors and windows can be broken); the flat map has
    # no stairs or roofs, so anyone the dead cannot reach is brought down to the nearest reachable floor
    zs = [cell(c) for c in people if c['kind'] == 'zombie']
    reach = flood(g, zs)
    moved = 0
    for c in people:
        if c['kind'] != 'zombie' and cell(c) not in reach:
            cc, rr = cell(c)
            spot = nearest_open(g, cc, rr, ok=lambda a, b: (a, b) in reach, reach=40)
            if spot:
                c['x'], c['z'] = left + (spot[0] + 0.5) * CELL, top + (spot[1] + 0.5) * CELL
                moved += 1
            else:
                c['kind'] = 'lost'
    if moved:
        notes.append('%d brought within reach of the dead' % moved)
    lost = sum(1 for c in people if c['kind'] == 'lost')
    if lost:
        notes.append('%d left out (nowhere reachable near them)' % lost)
    for c in people:
        if c['kind'] == 'human':
            m = c['model'].lower()
            c['role'] = 'soldier' if 'soldier' in m else 'police' if 'police' in m else 'civilian'
            c['sniper'] = ('Sniper' in name and c['y'] - floor > 1.4)
    count = lambda k: sum(1 for c in lv['cast'] if c['kind'] == k)
    return dict(name=name, next=lv['next'], hard=lv['hard'], win=lv['win'], lose=lv['lose'], grid=g,
                left=left, top=top, people=[c for c in people if c['kind'] != 'lost'], barriers=barriers,
                pistols=count('pistol'), rifles=count('rifle'), melee=count('melee'),
                walls=wall_segments(g), notes=notes)


def write(path):
    out = ['# uDead levels: made by tools/udg_to_udead.py from uDeadGame 2009 (do not edit by hand).',
           '# One block per level in play order. GRID rows: 1 = wall, 0 = floor, %g m cells.' % CELL,
           '# WALLS: outline runs in cell corners c1,r1,c2,r2. CAST: kind|x|z|facing|role|name (metres from the',
           '# map corner; role = civilian/police/soldier/sniper). BARRIER: kind|name|c,r c,r ... (cells it closes).', '']
    report = []
    for name in play_order():
        b = build(name)
        g = b['grid']
        out += ['LEVEL ' + b['name'], 'NEXT ' + b['next'], 'HARD ' + ('true' if b['hard'] else 'false'),
                'WIN ' + b['win'], 'LOSE ' + b['lose'],
                'ARMS %d %d %d' % (b['pistols'], b['rifles'], b['melee']),
                'GRID %d %d' % (len(g[0]), len(g))]
        out += [''.join(str(v) for v in row) for row in g]
        out.append('WALLS %d' % len(b['walls']))
        out += ['%d,%d,%d,%d' % w for w in b['walls']]
        out.append('CAST %d' % len(b['people']))
        for c in b['people']:
            role = 'sniper' if c.get('sniper') else c.get('role', '-')
            out.append('%s|%.2f|%.2f|%d|%s|%s' % (c['kind'], c['x'] - b['left'], c['z'] - b['top'],
                                                 round(c['ry']), role, c['model']))
        out.append('BARRIERS %d' % len(b['barriers']))
        for d in b['barriers']:
            out.append('%s|%s|%s' % (d['kind'], d['name'], ' '.join('%d,%d' % c for c in d['cells'])))
        out += ['END', '']
        k = lambda kind: sum(1 for c in b['people'] if c['kind'] == kind)
        report.append('%-20s %3dx%-3d walls %4d  dead %2d living %2d  guns %2d+%d melee %2d  doors/windows %2d  %s' % (
            b['name'], len(g[0]), len(g), len(b['walls']), k('zombie'), k('human'), b['pistols'], b['rifles'],
            b['melee'], len(b['barriers']), '; '.join(b['notes'])))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, 'w', encoding='utf-8', newline='\n').write('\n'.join(out))
    return report


def show(lv):
    tris = triangles(lv['mesh'])
    g, left, top, floor = grid_of(tris, lv['cast'])
    mark = {'human': 'h', 'zombie': 'Z', 'door': 'D', 'window': 'W', 'player': 'P'}
    pic = [['#' if v else '.' for v in row] for row in g]
    for c in lv['cast']:
        if c['kind'] in mark:
            cx, cz = int((c['x'] - left) / CELL), int((c['z'] - top) / CELL)
            if 0 <= cz < len(pic) and 0 <= cx < len(pic[0]):
                pic[cz][cx] = mark[c['kind']].upper() if not g[cz][cx] else mark[c['kind']].lower() if c['kind'] in ('door', 'window') else '!'
    print('%s  -> %s   %d tris  %dx%d  left %g top %g floor %.2f  calls %s' % (
        lv['name'], lv['next'], len(tris), len(g[0]), len(g), left, top, floor, lv['calls']))
    print('\n'.join(''.join(r) for r in pic))
    ks = {}
    for c in lv['cast']:
        ks[c['kind']] = ks.get(c['kind'], 0) + 1
    print(ks, ' y of humans:', sorted(round(c['y'], 1) for c in lv['cast'] if c['kind'] == 'human'))


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--show', help='print one level (name without UDG_)')
    a = ap.parse_args()
    if a.show:
        show(level(a.show))
    else:
        print('\n'.join(write(OUT)))
        print('wrote', os.path.normpath(OUT), os.path.getsize(OUT) // 1024, 'KB')
