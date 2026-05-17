# How to read this book

The book is structured to serve two distinct readers at once.

Hegel's *Logic* is simultaneously a formal system and a piece of
philosophy — the categorical and the conceptual co-develop, and
neither makes much sense alone. The two tracks honor that split:
the philosophy track follows the conceptual argument, the
programmer track follows the formal construction, and the "Reads
as" paraphrases bridge them. Most readers benefit from peeking at
the other track now and then.

Each chapter section uses some subset of these **facets**, each at
whatever length the pedagogy demands:

- **Hegelian thesis** — what Hegel claims, in his terms, with
  citations to the §§ of the *Science of Logic*.
- **Context** — where the move sits in the dialectical arc.
- **Intuition** — the picture, example, motivating analogy.
- **Math** — the categorical or type-theoretic content.
- **Code** — the Agda.
- **Reads as** — a natural-language bridge between code and concept.

Not every section uses every facet. The discipline is: **a reader
should be able to skim the facets foreign to their background and
still come away with what was claimed and whether it was verified.**

## If you come from philosophy

Your track is **Hegelian thesis → Context → Intuition → Reads as**.

You can skim or skip the Math and Code blocks. The "Reads as"
paraphrase tells you what the code is *claiming*, phrased as a
Hegelian assertion. If you want a quick check on whether a chapter
verified something, look for the "What we verified" block at the
end of every chapter.

If you encounter an Agda symbol you want to understand briefly, the
[Glossary](./glossary.md) explains every construct used in the
book in plain English. The [Cubical primitives](./cubical-primitives.md)
sidebar collects the more technical pieces.

## If you come from type theory or programming

Your track is **Math → Code → Reads as**.

You can skim the Hegelian-thesis sections, treating them as
motivation. The German terms get glossed; if you're not sure what
*Aufhebung* or *Wirklichkeit* mean, the [Glossary](./glossary.md)
covers them.

The book uses Cubical Agda. If you know plain Agda but not the
cubical extension, the [Cubical primitives reference](./cubical-primitives.md)
brings you up to speed in one page.

## If you come from both — or neither

Read everything. The book aims to keep both tracks short enough
that reading both is not punishing.

## On the order

The chapters are linear: each depends on the ones before. You can
skip ahead but you may have to flip back. The "Where we are" header
at the start of each chapter reminds you what's been built so far;
the "What's next" footer points forward.
