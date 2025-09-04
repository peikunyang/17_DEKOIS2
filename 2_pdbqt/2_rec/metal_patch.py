#!/usr/bin/env python
import os, re

ROOT = "../../2_pdbqt/1_pdbqt"
METAL_CHARGES = {
    "MG": 2.0, "ZN": 2.0, "CA": 2.0, "MN": 2.0, "FE": 2.0,
    "NA": 1.0, "K": 1.0, "CU": 2.0, "CO": 2.0, "NI": 2.0
}

def patch_line(line):
    if not (line.startswith("ATOM") or line.startswith("HETATM")): return line
    resn = line[17:20].strip().upper()
    elem = (line[76:78] if len(line) >= 78 else "").strip().upper()
    key = resn if resn in METAL_CHARGES else (elem if elem in METAL_CHARGES else None)
    if not key: return line
    q = "%.3f" % METAL_CHARGES[key]
    parts = line.rstrip("\n").split()
    if len(parts) >= 2:
        try:
            float(parts[-2]); parts[-2] = q
            return re.sub(r"\s+", " ", " ".join(parts)) + "\n"
        except Exception:
            parts.insert(-1, q)
            return re.sub(r"\s+", " ", " ".join(parts)) + "\n"
    return line.rstrip("\n") + "  " + q + "\n"

def main():
    count = 0
    for dp, _, fns in os.walk(ROOT):
        for fn in fns:
            if not fn.endswith(".pdbqt"): continue
            p = os.path.join(dp, fn)
            with open(p, "r") as f: lines = f.readlines()
            with open(p, "w") as f: f.writelines([patch_line(l) for l in lines])
            count += 1
    print("Patched %d files under %s" % (count, ROOT))

if __name__ == "__main__":
    main()

