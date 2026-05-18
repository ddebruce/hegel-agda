# Preface

## What this book is

This is a literate Cubical Agda program that walks through
fragments of G.W.F. Hegel's *Science of Logic* (1812–1816). Each
chapter pairs a Hegelian move with a verified type-theoretic
construction. Every claim that is not explicitly flagged as a
postulate is checked by the Agda typechecker — what you read is
what the compiler accepted.

The translation framework is the one developed by William Lawvere
and refined collaboratively on the nLab, identifying Hegelian
concepts (Concept, Judgment, Moment, Aufhebung, the adjoint triple
Possibility–Actuality–Necessity) with constructions from
categorical logic and homotopy type theory.

## What is Hegel trying to do?

The *Science of Logic* is Hegel's attempt to derive *every category
of thought* from no presupposition at all. He begins from Pure
Being — the emptiest possible concept — and shows that each
category, examined honestly, reveals an internal tension that
forces the move to the next. By the end, Being has become Quantity,
Quantity has become Essence, and Essence has become the Absolute
Idea, with every step justified by what came before. The wager is
that the categories of thought are not a static list to be
enumerated, but a self-developing sequence — and that following the
development *is* logic.

The engine of that development is a move classical logic treats as
a defect: *contradiction*. Hegel argues that contradictions, taken
seriously instead of explained away, are the productive moments
where thought moves forward. Pure Being collapses into Pure Nothing
not because Hegel made a mistake but because thinking each one
honestly leads, by itself, to the other. Out of that collapse comes
Becoming, and from Becoming the whole rest of the system. If the
move from Being to Nothing fails, the *Logic* fails at step one. If
it succeeds, the categories aren't arbitrary cultural artifacts —
they're the shape thought *had* to take.

## Why formalize?

Putting Hegel into Agda forces a kind of honesty that prose can't.
Every "transition" becomes either a verified construction — we
built it; the typechecker accepted it — or an explicit caveat:
here is where the formal version stops short of Hegel's claim, and
here is what we still gain anyway. The reader sees, line by line,
which parts of the dialectical machinery survive translation and
which don't.

That is worth doing whether you came to convince yourself Hegel is
formalizable or to convince yourself he isn't. The caveats are
called out at every point where Hegel says more than the
formalization can. Where the formalization succeeds, the proof is
on the page. Where it falls short, the gap is named and the reader
gets to weigh it.

## What this book is not

- **It is not a complete formalization of Hegel.** Six short
  chapters cover a fragment of Volume 1 (the Doctrine of Being)
  and the opening of Volume 2 (the Doctrine of Essence). The
  Doctrine of the Notion, the Doctrine of Actuality in detail,
  and much else, are not covered.
- **It is not an original mathematical contribution.** The
  Lawvere/nLab translation is the source of all the ideas. The
  implementation is a careful, pedagogical realization of a
  program that has been articulated elsewhere.
- **It is not a defense of the claim that Hegel can be
  formalized.** The claim is contested — Hegel himself argues
  in §1798 that consistent formal logic cannot capture the
  productive contradictions central to his system. We try to be
  explicit at each step about what is captured and what is not.

## The two tracks

Each chapter is structured so that **a philosophy reader** can
read just the Hegelian-thesis, Context, Intuition, and Reads-as
sections and walk away with the argument; **a programmer reader**
can read just the Math, Code, and Reads-as sections and walk away
with the construction. The "Reads as" paraphrases are the bridge
present in both tracks.

If you don't know either side, [How to read this book](./how-to-read.md)
explains the structure in more detail.

## What you need

- **No prior Agda knowledge.** Syntax is introduced as it
  appears. The shared [Cubical primitives reference](./cubical-primitives.md)
  collects everything Agda-specific in one place.
- **No prior Hegel.** German terms are glossed in the
  [Glossary](./glossary.md). Section numbers (e.g., §134) refer
  to the di Giovanni translation of the *Science of Logic*
  (Cambridge University Press, 2010), which is also the edition
  cited on the [nLab *Science of Logic* page](https://ncatlab.org/nlab/show/Science+of+Logic).

## Acknowledgments

The translation framework this book implements is due principally
to William Lawvere; its current articulation is collaborative work
on the [nLab](https://ncatlab.org/nlab/show/Science+of+Logic).
Recent suggestions about how Hegelian concepts surface in
topology and homotopy theory come from Clarence Protin's 2025
paper *Hegel and Modern Topology*. The Agda implementation
benefits from agda/cubical and the wider Agda community's work
on Cubical Agda.

The honest framing of "what is and isn't captured" owes a great
deal to several rounds of internal review during drafting.

## Contact & contributing

Questions, corrections, pushback, and collaboration are all welcome.

- **Errata, typos, technical issues** — open an issue at
  [github.com/ddebruce/hegel-agda/issues](https://github.com/ddebruce/hegel-agda/issues).
- **Discussion of the philosophy or formalization** —
  [github.com/ddebruce/hegel-agda/discussions](https://github.com/ddebruce/hegel-agda/discussions).
  Specific is more useful than general: "Chapter 4 §3 paragraph 2"
  beats "Chapter 4 was confusing."
- **Serious correspondence** (collaboration, citation, review) —
  [hello@ddebruce.com](mailto:hello@ddebruce.com).

I am especially interested in: places where the Lawvere/nLab
translation feels strained, candidates for a non-trivial Aufhebung
instance, and Doctrine-of-the-Notion material I have not yet
attempted.
