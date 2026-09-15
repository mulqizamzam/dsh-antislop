#!/usr/bin/env python3
"""contrast-check.py — WCAG contrast checker for the antislop human skill.

Usage:
    python3 contrast-check.py <fg> <bg>
    python3 contrast-check.py "#1a1a1a" "#ffffff"

Prints the contrast ratio and AA/AAA pass/fail for normal and large text.
Exits 0 if it meets AA for normal text (>=4.5), else 1.
Colors may be #rgb or #rrggbb (with or without the leading #).
"""
import sys


def parse_color(c):
    c = c.strip().lstrip("#")
    if len(c) == 3:
        c = "".join(ch * 2 for ch in c)
    if len(c) != 6:
        raise ValueError("color must be #rgb or #rrggbb: %r" % c)
    return tuple(int(c[i:i + 2], 16) for i in (0, 2, 4))


def _lin(channel):
    s = channel / 255.0
    return s / 12.92 if s <= 0.03928 else ((s + 0.055) / 1.055) ** 2.4


def luminance(rgb):
    r, g, b = (_lin(x) for x in rgb)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def ratio(fg, bg):
    l1, l2 = luminance(fg), luminance(bg)
    lighter, darker = max(l1, l2), min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)


def main(argv):
    if len(argv) != 3:
        sys.stderr.write(__doc__)
        return 2
    try:
        fg = parse_color(argv[1])
        bg = parse_color(argv[2])
    except ValueError as e:
        sys.stderr.write("error: %s\n" % e)
        return 2
    r = ratio(fg, bg)
    aa_normal = r >= 4.5
    aa_large = r >= 3.0
    aaa_normal = r >= 7.0
    aaa_large = r >= 4.5
    print("contrast ratio: %.2f:1" % r)
    print("  AA  normal text (>=4.5): %s" % ("PASS" if aa_normal else "FAIL"))
    print("  AA  large  text (>=3.0): %s" % ("PASS" if aa_large else "FAIL"))
    print("  AAA normal text (>=7.0): %s" % ("PASS" if aaa_normal else "FAIL"))
    print("  AAA large  text (>=4.5): %s" % ("PASS" if aaa_large else "FAIL"))
    return 0 if aa_normal else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
