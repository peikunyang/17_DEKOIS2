#!/usr/bin/env bash
set -euo pipefail

# === Roots (keep original subfolder structure) ===
IN_ROOT="/home/kun/job/17_DEKOIS2/1_ori/1_smiles/DEKOIS2"
OUT_ROOT="/home/kun/job/17_DEKOIS2/2_pdbqt/1_pdbqt"

# === ADT (run inside adt_py27) ===
PYSH="${CONDA_PREFIX}/bin/pythonsh"
PL4="${CONDA_PREFIX}/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py"

[[ -x "$PYSH" ]] || { echo "[ERROR] pythonsh not found (activate adt_py27)"; exit 1; }
[[ -f "$PL4"  ]] || { echo "[ERROR] prepare_ligand4.py not found: $PL4"; exit 1; }

# === Open Babel CLI (must be on PATH) ===
command -v obabel >/dev/null 2>&1 || { echo "[ERROR] obabel not found (install in any py3 env)"; exit 1; }

# Common metal atomic numbers (includes Ru=44). Adjust as needed.
METAL_ATOMNUMS=(22 23 24 25 26 27 28 29 30 40 41 42 43 44 45 46 47 48 49 50 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79)
# Or only Ru:
# METAL_ATOMNUMS=(44)

# Single log file
FAILED_LOG="$(pwd)/failed.log"
: > "$FAILED_LOG"

# Build combined delete args once
DELETE_ARGS=()
for Z in "${METAL_ATOMNUMS[@]}"; do
  DELETE_ARGS+=( --delete "[#${Z}]" )
done

find "$IN_ROOT" -type f -path "*/protein/*_ligand.mol2" -print0 |
while IFS= read -r -d '' f; do
  rel_path="${f#$IN_ROOT/}"                       # e.g., 11betahsd1/protein/xxx_ligand.mol2
  target_dir="$OUT_ROOT/$(dirname "$rel_path")"   # e.g., /.../1_pdbqt/11betahsd1/protein
  base="$(basename "$f" .mol2)"
  out="$target_dir/${base}.pdbqt"

  tmpdir="$(mktemp -d)"
  cp "$f" "$tmpdir/in.mol2"
  src="$tmpdir/in.mol2"

  # Rough metal detection by element symbol in the original file
  if grep -Eiq "\b(Fe|Zn|Cu|Ni|Co|Mn|Mg|Ca|Na|K|Ru|Rh|Pd|Ag|Ir|Pt|Au|Os|Ti|V)\b" "$f"; then
    # Remove metals (do NOT overwrite in place; specify -i/-o explicitly)
    if ! obabel -imol2 "$src" -omol2 -O "$tmpdir/demet.mol2" "${DELETE_ARGS[@]}" >/dev/null 2>&1; then
      echo "$f" >> "$FAILED_LOG"; rm -rf "$tmpdir"; continue
    fi
    # Re-add H / fix valence at pH 7.4
    if ! obabel -imol2 "$tmpdir/demet.mol2" -omol2 -O "$tmpdir/ready.mol2" -p 7.4 >/dev/null 2>&1; then
      echo "$f" >> "$FAILED_LOG"; rm -rf "$tmpdir"; continue
    fi
    src="$tmpdir/ready.mol2"
  fi

  mkdir -p "$target_dir"
  echo "[convert] $f -> $out"
  if ( cd "$(dirname "$src")" && "$PYSH" "$PL4" -l "$(basename "$src")" -o "$out" -A hydrogens ); then
    :
  else
    echo "$f" >> "$FAILED_LOG"
  fi

  rm -rf "$tmpdir"
done

echo "[done] failures are listed in: $FAILED_LOG"

