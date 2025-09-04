#!/usr/bin/env bash
set -euo pipefail

INPUT_ROOT="../../1_ori/1_smiles/DEKOIS2"
OUTPUT_ROOT="../../2_pdbqt/1_pdbqt"
FAILED_LIST="failed_adt.list"

if [ ! -s "$FAILED_LIST" ]; then
  echo "No ADT failures. Nothing to do."
  exit 0
fi

while IFS= read -r f; do
  [ -z "$f" ] && continue
  rel="${f#${INPUT_ROOT}/}"
  out="${OUTPUT_ROOT}/${rel%.pdb}.pdbqt"
  mkdir -p "$(dirname "$out")"
  echo "[OBABEL] $f -> $out"
  obabel -ipdb "$f" -opdbqt -O "$out" -h --partialcharge gasteiger --pH 7.4
done < "$FAILED_LIST"

echo "Open Babel fallback done."

