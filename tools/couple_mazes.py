#!/usr/bin/env python3
"""couple_mazes.py - Amazing Couple's mazes, made ONCE as cellmap v2 files (owner's game note,
11 14 2026: "lets make the maps procedurally ONCE so we can test for things ... before having
random bugs every build").

  python3 -I tools/couple_mazes.py [count]     writes LIB_BIT/editor/maps/amazing_couple_mazes/
                                               maze_01.cellmap ... and CHECK.txt
  python3 -I tools/couple_mazes.py --help      this text

Each maze is the same one the game used to build at run time (Bit.Maze(6, 6, seed), ported as
cellmap.maze), so maze_01 is the first maze the owner has walked. Walls: tag '#', floor 100
(a full wall = wallH engine units), Aquarius line pieces as their glyphs, so the BitEditor shows
them as drawn lines. Corridors: tag '.', floor 1 (flat ground).

The check (written to CHECK.txt, and the exit code is 1 on any fault), for every maze:
  0. the file holds the maze that was meant (heights against the generator's grid);
  1. the beacon's corner can be reached from the first room;
  2. walking (cellmap.walk, the heroes' radius 12) is blocked by every cell DRAWN as a wall
     (floor 100+) and by nothing else, tags included: from the middle of every open cell, a step toward each neighbour moves
     exactly when that neighbour is open;
  3. the drawn walls (cellmap.level_segments, class 'wall') lie only on the edges of wall
     cells, and every edge between a wall cell and an open cell is drawn.
Since the game now draws AND collides from the same file, 2 and 3 together mean: no invisible
walls, no walls you can walk through.
"""
import os, sys
from collections import deque

HERE = os.path.dirname(os.path.abspath(__file__))
PROJ = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(PROJ, 'LIB_BIT', 'editor', 'python'))
import cellmap  # noqa: E402

ROOMS = 6            # the game's kRooms
CELL = 76            # kCell
WALLH = 58           # kWallH
OUT = os.path.join(PROJ, 'LIB_BIT', 'editor', 'maps', 'amazing_couple_mazes')


def make(seed):
    grid = cellmap.maze(ROOMS, ROOMS, seed)
    rows, cols = len(grid), len(grid[0])
    m = cellmap.new_map2(cols, rows, name='amazing_couple_maze_%02d' % seed, cell=CELL,
                         wallH=WALLH, font='Aquarius')
    for r, line in enumerate(grid):
        for c, ch in enumerate(line):
            if ch == '1':
                m['tags'][r][c] = '#'
                m['design'][r][c] = ord('#')
                m['floor'][r][c] = 100
            else:
                m['tags'][r][c] = '.'
                m['design'][r][c] = ord('.')
                m['floor'][r][c] = 1              # 1 = flat ground (0 would be empty space)
    cellmap.autowall(m)            # line pieces for the editor's eyes; heights untouched
    for r, line in enumerate(grid):  # (autowall must not have changed what is a wall)
        for c, ch in enumerate(line):
            assert (m['floor'][r][c] >= 100) == (ch == '1'), (seed, r, c)
    return m, grid


def check(m, grid, seed):
    faults = []
    rows, cols = len(grid), len(grid[0])
    tags = cellmap.tag_lookup()
    # "open" as the DRAWING shows it: the file's own heights (a full wall is floor 100 or more).
    # Walking is compared with this, not with the intended grid, so a cell that blocks by its
    # tag but is drawn low (an invisible wall) is caught; the grid is checked against it in 0.
    def open_(c, r):                      # 1-based
        return 1 <= c <= cols and 1 <= r <= rows and 0 < m['floor'][r - 1][c - 1] < 100
    # 0. the file is the maze that was meant
    for r in range(1, rows + 1):
        for c in range(1, cols + 1):
            if open_(c, r) != (grid[r - 1][c - 1] == '0'):
                faults.append('cell %d,%d is drawn %s but the maze has a %s' % (c, r,
                              'open' if open_(c, r) else 'as a wall', 'corridor' if grid[r - 1][c - 1] == '0' else 'wall'))
    # 1. reach the beacon
    start, goal = (2, 2), (2 * ROOMS, 2 * ROOMS)
    seen, q = {start}, deque([start])
    while q:
        c, r = q.popleft()
        for dc, dr in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (c + dc, r + dr)
            if open_(*n) and n not in seen:
                seen.add(n)
                q.append(n)
    if goal not in seen:
        faults.append('the beacon corner %s cannot be reached' % (goal,))
    # 2. walking agrees with the grid
    step = CELL * 0.6
    for r in range(1, rows + 1):
        for c in range(1, cols + 1):
            if not open_(c, r):
                continue
            x, z = cellmap.cell_x(m, c), cellmap.cell_z(m, r)
            y0 = cellmap.ground_at(m, tags, None, x, z)
            if y0 is None:
                faults.append('cell %d,%d: open but nobody can stand there' % (c, r))
                continue
            for dc, dr in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, nz, _, _ = cellmap.walk(m, tags, None, x, z, y0, dc * step, dr * step, 12)
                moved = abs(nx - x) + abs(nz - z) > 1e-6
                if moved != open_(c + dc, r + dr):
                    faults.append('cell %d,%d step %+d,%+d: moved=%s but the neighbour is %s'
                                  % (c, r, dc, dr, moved, 'open' if open_(c + dc, r + dr) else 'wall'))
    # 3. drawn walls sit on wall-cell edges, and every wall/open edge is drawn.
    # level_segments: 'x1,y1,z1,x2,y2,z2,class', x and z in sixteenths of a cell, runs merged;
    # split every flat run into unit cell edges: ('h', col, z) lies between rows z and z+1,
    # ('v', x, row) between columns x and x+1 (1-based cells, 0 = outside)
    drawn = set()
    for seg in cellmap.level_segments(m, tags, None):
        f = seg.split(',')
        if f[6] != 'wall':
            continue
        x1, z1, x2, z2 = (float(f[i]) / 16 for i in (0, 2, 3, 5))
        if abs(x1 - x2) < 1e-6 and abs(z1 - z2) < 1e-6:
            continue                       # an upright corner line
        if abs(z1 - z2) < 1e-6:
            for u in range(int(round(min(x1, x2))), int(round(max(x1, x2)))):
                drawn.add(('h', u + 1, int(round(z1))))
        else:
            for u in range(int(round(min(z1, z2))), int(round(max(z1, z2)))):
                drawn.add(('v', int(round(x1)), u + 1))
    def kind(c, r):
        if not (1 <= c <= cols and 1 <= r <= rows):
            return 'outside'
        return 'open' if open_(c, r) else 'wall'
    def sides(e):
        if e[0] == 'h':
            return (e[1], e[2]), (e[1], e[2] + 1)
        return (e[1], e[2]), (e[1] + 1, e[2])
    for e in drawn:
        a, b = (kind(*p) for p in sides(e))
        if 'wall' not in (a, b) or a == b:
            faults.append('a wall line %s is drawn between %s and %s' % (e, a, b))
    for r in range(0, rows + 1):
        for c in range(0, cols + 1):
            for e in (('h', c, r), ('v', c, r)):
                a, b = (kind(*p) for p in sides(e))
                if {a, b} == {'wall', 'open'} and e not in drawn:
                    faults.append('the edge %s between a wall and a corridor is not drawn' % (e,))
    return faults, len(drawn)


def main():
    if any(a in ('-h', '--help') for a in sys.argv[1:]):   # A-50: every tool answers --help
        print(__doc__)
        return 0
    try:
        count = int(sys.argv[1]) if len(sys.argv) > 1 else 12
    except ValueError:
        print('couple_mazes.py: count must be a whole number (try --help)')
        return 2
    os.makedirs(OUT, exist_ok=True)
    report, bad = [], 0
    for seed in range(1, count + 1):
        m, grid = make(seed)
        path = os.path.join(OUT, 'maze_%02d.cellmap' % seed)
        cellmap.write_map(m, path)
        back = cellmap.read_map(path)           # check what was written, not what is in memory
        cellmap.upgrade(back)
        faults, n = check(back, grid, seed)
        bad += bool(faults)
        report.append('maze_%02d  %s  (%d wall lines)' % (seed, 'OK' if not faults else '%d FAULTS' % len(faults), n))
        report += ['   ' + f for f in faults[:20]]
    text = '\n'.join(['Amazing Couple mazes, checked by tools/couple_mazes.py', ''] + report) + '\n'
    open(os.path.join(OUT, 'CHECK.txt'), 'w').write(text)
    print(text)
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
