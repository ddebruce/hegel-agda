#!/usr/bin/env bash
# Copy literate-Agda chapter sources into plain markdown so mdBook can read them,
# then build the book. The .lagda.md files are canonical (Agda typechecks them);
# the .md copies are throwaway and gitignored.

set -euo pipefail

cd "$(dirname "$0")/.."

shopt -s nullglob
for f in book/src/*.lagda.md; do
  cp "$f" "${f%.lagda.md}.md"
done

mdbook build book
