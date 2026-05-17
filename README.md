# Hegel-Agda

A tutorial implementation of fragments of Hegel's *Science of Logic*
in Cubical Agda, following the Lawvere/Schreiber/nLab translation
program.

**Read the book online:** https://ddebruce.github.io/hegel-agda/

## Local development

### Prerequisites

- Agda 2.7.0.1 or 2.8.0 (CI uses 2.7.0.1)
- agda/cubical registered in `~/.agda/libraries` (v0.8 if on 2.7.0.1; v0.9 if on 2.8.0)
- mdBook (latest)

### Typecheck the Agda

```bash
cd book/src
for f in *.lagda.md; do agda "$f"; done
```

### Build and preview the book

```bash
./scripts/build-book.sh && mdbook serve book --open
```

This builds the book and opens it in your browser at `http://localhost:3000`.
Edits to the markdown files trigger automatic rebuilds.

## Layout

- `book/src/` — canonical `.lagda.md` source for the book. Agda typechecks
  these files directly and mdBook renders them.
- `book/book.toml` — mdBook configuration.
- `hegel.agda-lib` — Agda library file pointing at `book/src/`.
- `.github/workflows/deploy.yml` — CI that typechecks and deploys.

> **Why the script?** mdBook does not natively render `.lagda.md`
> files. The script copies them to `.md` (which mdBook reads) before
> building. The `.lagda.md` files are canonical for Agda typechecking;
> the `.md` copies are throwaway build artifacts and are gitignored.

## Contact

- Errata and bugs: [open an issue](https://github.com/ddebruce/hegel-agda/issues)
- Philosophy / formalization discussion: [Discussions](https://github.com/ddebruce/hegel-agda/discussions)
- Collaboration, citation, review: [hello@ddebruce.com](mailto:hello@ddebruce.com)

## License

Dual licensed: code is MIT, prose is CC-BY-4.0. See [LICENSE](./LICENSE).

Copyright 2026 David DeBruce.
