#!/usr/bin/env bash
set -euo pipefail

# input protein pdb files
INPUT_ROOT="../../1_ori/1_smiles/DEKOIS2"
# output folder for pdbqt
OUTPUT_ROOT="../../2_pdbqt/1_pdbqt"
FAILED_LIST="failed_adt.list"

mkdir -p "$OUTPUT_ROOT"
: > "$FAILED_LIST"

# find all *.pdb under protein/, but exclude *pocket*
find "$INPUT_ROOT" -path "*/protein/*.pdb" ! -iname "*pocket*" -print0 | \
while IFS= read -r -d '' f; do
  rel="${f#${INPUT_ROOT}/}"
  out="${OUTPUT_ROOT}/${rel%.pdb}.pdbqt"
  mkdir -p "$(dirname "$out")"
  echo "[ADT] $f -> $out"
  if prepare_receptor4.py -r "$f" -o "$out" -A hydrogens >/dev/null 2>&1; then
    echo "  OK"
  else
    echo "  FAIL -> recorded"
    echo "$f" >> "$FAILED_LIST"
  fi
done

echo "ADT pass done. Failed list: ${FAILED_LIST}"

