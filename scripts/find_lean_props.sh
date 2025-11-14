#!/usr/bin/env bash
set -euo pipefail

# Find Lean propositions and write a CSV of file_path, line, prop_name.
#
# Heuristics covered:
#  - theorem/lemma/corollary/axiom/constant (with optional attributes and qualifiers)
#  - def/definition/abbrev whose type is Prop (same-line type annotation)
#  - lines starting with `thm` (repository-specific shorthand if present)
#
# Usage:
#   scripts/find_lean_props.sh [OUT_CSV] [SEARCH_ROOT]
# Defaults:
#   OUT_CSV     -> ./lean_props.csv
#   SEARCH_ROOT -> .

OUT_CSV="${1:-lean_props.csv}"
SEARCH_ROOT="${2:-.}"

mkdir -p "$(dirname -- "$OUT_CSV")"

echo 'file_path, line, prop_name' > "$OUT_CSV"

if command -v rg >/dev/null 2>&1; then
  # Patterns (PCRE2). We use \K so matches return just the name token.
  # Allow optional attributes like `@[simp]` and qualifiers like `private`, `local`, etc.
  PAT_THEOREM='^\s*(?:@\[[^\]]*\]\s*)*(?:(?:private|protected|local|scoped|noncomputable|unsafe)\s+)*(?:theorem|lemma|corollary|axiom|constant)\s+\K[^\s:(]+'
  PAT_DEF_PROP='^\s*(?:@\[[^\]]*\]\s*)*(?:(?:private|protected|local|scoped|noncomputable|unsafe)\s+)*(?:def|definition|abbrev)\s+\K[^\s:(]+(?=[^:\n]*:\s*Prop\b)'
  PAT_THM_SHORTHAND='^\s*(?:@\[[^\]]*\]\s*)*thm\s+\K[^\s:(]+'

  # Search only .lean files, output as vimgrep: file:line:col:match
  rg --pcre2 --vimgrep -n -H -o \
     -g '*.lean' \
     -e "$PAT_THEOREM" \
     -e "$PAT_DEF_PROP" \
     -e "$PAT_THM_SHORTHAND" \
     "$SEARCH_ROOT" 2>/dev/null \
  | sort -t: -k1,1 -k2,2n \
  | awk -F: '
      BEGIN { OFS=","; q = sprintf("%c", 34) }
      {
        file=$1; line=$2; name=$4;
        gsub(q, q q, file); gsub(q, q q, name);
        printf q "%s" q ", %s, " q "%s" q "\n", file, line, name;
      }
    ' >> "$OUT_CSV"
else
  echo "Error: ripgrep (rg) is required for this script. Please install rg." >&2
  exit 1
fi

rows=$(( $(wc -l < "$OUT_CSV") - 1 ))
echo "Wrote ${rows} rows to $OUT_CSV" >&2
