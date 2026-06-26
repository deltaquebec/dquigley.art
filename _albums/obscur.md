---
title: Obscur
description: "Obscuring the camera"
order: 1
# --- album ordering on the /gallery/ index ---
# `order` sorts the album cards (ascending). give every album one.
#
# --- photo source: two modes ---
# default (no `photos:` key): images are globbed from /album/berlin/ and
# ordered by filename. control order by zero-padded names (berlin-01, -02, ...).
# add optional captions, keyed by file basename (no extension):
#
# captions:
#   berlin-01: "Alexanderplatz at dusk."
#   berlin-03: "Spree, looking east."
#
# explicit mode: list `photos:` to set order and metadata directly,
# decoupled from filenames. each entry: file (required), caption, alt.
#
# photos:
#   - file: berlin-03.jpeg
#     caption: "Spree, looking east."
#     alt: "river at golden hour"
#   - file: berlin-01.jpeg
#     caption: "Alexanderplatz at dusk."
#
# other optional keys:
# dir   - source folder if it differs from the slug (default: berlin)
# cover - thumbnail for the index card (default: first image)
---
