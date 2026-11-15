#!/usr/bin/env python3
"""LIB_GAMES's check that runs without LiveCode (A-50): uDead's level grid helpers (open cells,
flood fill, nearest open cell) on a small grid made here. The game scripts need the engine.

    python3 -I tests/run_tests.py
"""
import os, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import udg_to_udead as ud                   # noqa: E402

CHECKS, FAILS = [0], []


def check(name, ok, got=None):
    CHECKS[0] += 1
    if not ok:
        FAILS.append(name)
        print("FAIL  %s%s" % (name, "" if got is None else "  (got %r)" % (got,)))
    else:
        print("ok    %s" % name)


def done():
    print("\n%d of %d passed" % (CHECKS[0] - len(FAILS), CHECKS[0]))
    return 1 if FAILS else 0


GRID = [[1, 1, 1, 1, 1],          # 1 = wall
        [1, 0, 0, 1, 1],
        [1, 0, 1, 1, 0],
        [1, 1, 1, 1, 0]]


def main():
    check('a wall is not open, a floor is', not ud.open_cell(GRID, 0, 0) and ud.open_cell(GRID, 1, 1))
    check('outside the grid is not open', not ud.open_cell(GRID, -1, 1) and not ud.open_cell(GRID, 5, 1))
    room = ud.flood(GRID, [(1, 1)])
    check('flood fills the room and stops at walls', room == {(1, 1), (2, 1), (1, 2)}, room)
    check('the closed-off corner is not reached', (4, 2) not in room)
    check('nearest open cell to a wall', ud.nearest_open(GRID, 0, 0) == (1, 1), ud.nearest_open(GRID, 0, 0))
    check('nothing open in reach', ud.nearest_open([[1, 1], [1, 1]], 0, 0) is None)
    return done()


if __name__ == '__main__':
    sys.exit(main())
