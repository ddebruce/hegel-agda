# Hegel-Agda

A tutorial implementation of fragments of Hegel's *Science of Logic*
in Cubical Agda, following the Lawvere/Schreiber/nLab translation
program.

**Read the book online:** https://ddebruce.github.io/hegel-agda/

## Local development

### Prerequisites

- Agda 2.8.0
- agda/cubical v0.9 registered in `~/.agda/libraries`
- mdBook (latest)

### Typecheck the Agda

```bash
cd book/src
for f in *.lagda.md; do agda "$f"; done
```

### Build and preview the book

```bash
mdbook serve book --open
```

This builds the book and opens it in your browser at `http://localhost:3000`.
Edits to the markdown files trigger automatic rebuilds.

## Layout

- `book/src/` — canonical `.lagda.md` source for the book. Agda typechecks
  these files directly and mdBook renders them.
- `book/book.toml` — mdBook configuration.
- `hegel.agda-lib` — Agda library file pointing at `book/src/`.
- `.github/workflows/deploy.yml` — CI that typechecks and deploys.

## License

Dual licensed: code is MIT, prose is CC-BY-4.0. See [LICENSE](./LICENSE).

Copyright 2026 David DeBruce.
