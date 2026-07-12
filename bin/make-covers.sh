#!/usr/bin/env bash
# generate work cover images (waveform, score page, video poster).
#
# usage:
#   bin/make-covers.sh            # all works under works/
#   bin/make-covers.sh nocturne   # one work
#
# per works/<slug>/, writes whichever apply:
#   *.pdf                  -> works/<slug>/score-cover.png  (page 1)
#   *.m4a|mp3|wav|flac|ogg -> works/<slug>/waveform.png
#   *.mp4|mov|webm|mkv     -> works/<slug>/poster.jpg       (frame at 3s)
#
# then point `cover:` in the piece front matter at the file you want.
#
# requires: ffmpeg (audio, video), pdftoppm from poppler (pdf).
#   macos:  brew install ffmpeg poppler
#   debian: sudo apt install ffmpeg poppler-utils

set -euo pipefail
cd "$(dirname "$0")/.."

shopt -s nullglob nocaseglob

# dark-theme palette: background and waveform color
BG="0x191919"
WAVE="0x00affa"

first() { for f in "$@"; do [ -e "$f" ] && { printf '%s' "$f"; return; }; done; }

make_one() {
  local slug="$1"
  local dir="works/$slug"
  [ -d "$dir" ] || { echo "skip: no $dir"; return; }

  local pdf audio video
  pdf="$(first "$dir"/*.pdf)"
  audio="$(first "$dir"/*.m4a "$dir"/*.mp3 "$dir"/*.wav "$dir"/*.flac "$dir"/*.ogg)"
  video="$(first "$dir"/*.mp4 "$dir"/*.mov "$dir"/*.webm "$dir"/*.mkv)"

  if [ -n "$pdf" ]; then
    pdftoppm -png -singlefile -f 1 -l 1 -r 150 "$pdf" "$dir/score-cover"
    echo "  $pdf -> $dir/score-cover.png"
  fi

  if [ -n "$audio" ]; then
    ffmpeg -y -loglevel error -i "$audio" -filter_complex \
      "color=c=$BG:s=1200x400[bg];[0:a]showwavespic=s=1200x400:colors=$WAVE[fg];[bg][fg]overlay=format=auto" \
      -frames:v 1 "$dir/waveform.png"
    echo "  $audio -> $dir/waveform.png"
  fi

  if [ -n "$video" ]; then
    ffmpeg -y -loglevel error -ss 3 -i "$video" -frames:v 1 -q:v 3 "$dir/poster.jpg"
    echo "  $video -> $dir/poster.jpg"
  fi
}

if [ "$#" -ge 1 ]; then
  make_one "$1"
else
  for d in works/*/; do
    make_one "$(basename "$d")"
  done
fi
echo "done."
