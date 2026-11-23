#!/usr/bin/env python3
"""A4 print quote. Prices in BDT (edit to match your costs)."""
RATE = {"bw": 3.0, "color": 10.0}   # per page
def quote(pages, mode="bw", copies=1, binding=0.0):
    return round(pages * RATE[mode] * copies + binding, 2)
if __name__ == "__main__":
    assert quote(10, "bw", 2) == 60.0
    print("sample quote (25pp color):", quote(25, "color"))
