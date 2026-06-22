#!/usr/bin/env bash
# generate gallery thumbnails.
#
# usage:
#   bin/make-thumbs.sh            # all albums under album/
#   bin/make-thumbs.sh berlin     # one album
#
# reads  album/<slug>/*.{jpg,jpeg,png}
# writes thumb/<slug>/<same-name>  (longest side <= 800px, stripped, q82)
#
# requires imagemagick (`convert`). run after adding or changing images,
# then commit both album/<slug>/ and thumb/<slug>/.

set -euo pipefail
cd "$(dirname "$0")/.."

shopt -s nullglob nocaseglob

make_one() {
  local slug="$1"
  local src="album/$slug"
  local dst="thumb/$slug"
  [ -d "$src" ] || { echo "skip: no $src"; return; }
  mkdir -p "$dst"
  for f in "$src"/*.jpg "$src"/*.jpeg "$src"/*.png; do
    local b
    b="$(basename "$f")"
    convert "$f" -resize '800x800>' -strip -quality 82 "$dst/$b"
    echo "  $f -> $dst/$b"
  done
}

if [ "$#" -ge 1 ]; then
  make_one "$1"
else
  for d in album/*/; do
    make_one "$(basename "$d")"
  done
fi
echo "done."
