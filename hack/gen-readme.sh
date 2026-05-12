#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
README="$ROOT_DIR/README.md"
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

# apko base configs included by other images, not published directly
EXCLUDE=(
  "$ROOT_DIR/wolfi-base.yaml"
  "$ROOT_DIR/alpine-base.yaml"
)

# Generate the images table sorted by image name
{
  printf '| Image | Pull |\n'
  printf '| --- | --- |\n'

  find "$ROOT_DIR" -type f -name '*.yaml' \
    | grep -v "^$ROOT_DIR/packages/" \
    | grep -v "^$ROOT_DIR/\.github/" \
    | grep -vF "$(printf '%s\n' "${EXCLUDE[@]}")" \
    | awk -F/ '{print $NF "\t" $0}' \
    | sort \
    | cut -f2- \
    | while IFS= read -r file; do
        relpath="${file#$ROOT_DIR/}"
        base=$(basename "$file" .yaml)
        printf '| [%s](./%s) | [`ghcr.io/vaskozl/%s`](https://github.com/vaskozl/containers/pkgs/container/%s) |\n' \
          "$base" "$relpath" "$base" "$base"
      done
} > "$TMPFILE"

# Splice the new table into README between ## Images and the next ## heading
awk -v tfile="$TMPFILE" '
  /^## Images$/ {
    print
    print ""
    while ((getline line < tfile) > 0) print line
    in_images = 1
    next
  }
  in_images && /^## / { in_images = 0 }
  !in_images { print }
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

echo "Updated $README"
