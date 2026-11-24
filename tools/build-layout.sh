#!/usr/bin/env bash
# Copies the shared header and footer into every page.
#
#   Edit  partials/header.html  or  partials/footer.html,  then run:
#     bash tools/build-layout.sh
#
# Each page has marker comments; everything between them is replaced:
#   <!-- SITE:HEADER:START --> ... <!-- SITE:HEADER:END -->
#   <!-- SITE:FOOTER:START --> ... <!-- SITE:FOOTER:END -->
# The page's own nav link is marked aria-current="page" (key = file name).
set -euo pipefail
cd "$(dirname "$0")/.."

PAGES="index service portfolio projects about contact-us thank-you webdev_lp"

for p in $PAGES; do
  f="$p.html"
  [ -f "$f" ] || { echo "skip: $f not found"; continue; }
  key="$p"; [ "$p" = "index" ] && key="home"
  hdr=$(sed "s#data-nav=\"$key\"#data-nav=\"$key\" aria-current=\"page\"#" partials/header.html)
  ftr=$(cat partials/footer.html)
  HDR="$hdr" FTR="$ftr" awk '
    /<!-- SITE:HEADER:START -->/ {print; print ENVIRON["HDR"]; skip=1; next}
    /<!-- SITE:HEADER:END -->/   {skip=0}
    /<!-- SITE:FOOTER:START -->/ {print; print ENVIRON["FTR"]; skip=1; next}
    /<!-- SITE:FOOTER:END -->/   {skip=0}
    !skip {print}
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  echo "updated: $f"
done
