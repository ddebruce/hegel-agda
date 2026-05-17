# Chapter 2 — The Logic of Being

```agda
{-# OPTIONS --cubical --guardedness #-}

module ch02-being where
```

## Where we are

[Chapter 1](./ch01-foundations.md) introduced Concepts (types),
Judgments (typing), and the Syllogism (function composition).
Those Concepts were postulated — we never asked "what is the
*simplest possible* Concept?"

The *Science of Logic* begins not with the syllogism but with the
pair **Pure Being** ([Sein](./glossary.md#sein-pure-being)) and **Pure Nothing** ([Nichts](./glossary.md#nichts-pure-nothing)). Hegel
argues these are equally indeterminate, and their tension gives
rise to **Becoming** ([Werden](./glossary.md#werden-becoming)). Here we set up the type-theoretic
correspondents:

| Hegelian concept | Type-theoretic correspondent          |
| ---------------- | ------------------------------------- |
| Pure Being       | `⊤` (unit type; one inhabitant)       |
| Pure Nothing     | `⊥` (empty type; zero inhabitants)    |
| Becoming         | The obvious functions `⊥ → X` and `X → ⊤` |

## 1. Pure Being (Das Sein)

### Hegelian thesis

Hegel's **Pure Being** is the most abstract concept possible: pure
existence without any further qualities. "X is" — said of nothing
in particular and without further specification.

The *Science of Logic* opens with this concept (§132). Hegel
emphasizes that Pure Being has no determinations whatsoever: no
content, no internal distinction, no relation. It is the absolute
beginning precisely because it presupposes nothing.

### Intuition

A type-theoretic correspondent should be a type that "just is" —
inhabited, but trivially. The natural choice: a type with exactly
one inhabitant, where the inhabitant carries no information. That
is the **unit type**, traditionally written `⊤` ("top").

### In code

Agda's `record` keyword defines a type whose values are tuples of
fields. A record with **no fields** and a single constructor `tt`
is inhabited by exactly one value.

```agda
record ⊤ : Set where
  constructor tt
```

### Reads as

*"Pure Being `⊤` is the type whose sole inhabitant is `tt`, with
no further data."*

## 2. Pure Nothing (Das Nichts)

### Hegelian thesis

Hegel's **Pure Nothing** is the categorical opposite of Pure Being:
the concept under which nothing falls. He insists that Pure Nothing
is not merely "the absence of being" but a positive thinking of the
non-being itself.

The *Science of Logic* asserts that Pure Nothing has the same
indeterminacy as Pure Being. Both lack any qualities. This is
already the seed of the dialectical move to come — but we develop
that in Section 3.

### In code

In type theory the categorial opposite of "one inhabitant" is "no
inhabitants." We declare a type with `data` and provide no
constructors. There is then no way to build a term of type `⊥`,
and under propositions-as-types, `⊥` is the proposition that is
provably false.

```agda
data ⊥ : Set where
  -- (intentionally no constructors)
```

### Reads as

*"Pure Nothing `⊥` is the type with no inhabitants whatsoever."*

## 3. Becoming (Das Werden)

### Hegelian thesis

Hegel's central early move: Being and Nothing are equally
indeterminate, so they "pass over into each other." Their truth is
**Becoming** — the movement between them (§134 ff.). The famous
formulation is that *Sein* and *Nichts* are identical *in their
truth*.

> **Caveat:** This chapter only models the *form* of the transition
> — two functions, one in each direction. The much stronger claim
> that Sein and Nichts are *identical* is formalized in
> [Chapter 4](./ch04-unity-aufhebung.md) using a Higher Inductive
> Type. Consistent formal logic cannot make `⊤` and `⊥` judgmentally
> equal, so the identification will happen at the path level rather
> than the equation level. (See [Higher Inductive
> Types](./cubical-primitives.md#higher-inductive-types-hits) for
> the relevant Cubical primitive.)

### Intuition

For now, a first weak way to model the transition: any type `X`
sits "between" `⊥` and `⊤`, because there is a unique function
`⊥ → X` (the principle of explosion: *from nothing, anything
follows*) and a unique function `X → ⊤` (any determinate thing can
be stripped of its qualities and reduced to bare existence).

```text
        ⊥ ───── from-nothing ─────▶ X ───── to-being ─────▶ ⊤
```

These functions exist for trivial categorical reasons (`⊥` is
initial, `⊤` is terminal in the category of types). They carry no
information in themselves — Chapter 4 will give the transition real
content.

### In code

The function from Nothing into any type uses the **[absurd pattern](./cubical-primitives.md#absurd-patterns)**
`()`. This tells Agda: "there are no inhabitants of `⊥` to
consider, so this function is defined everywhere it needs to be
defined (which is nowhere)."

```agda
from-nothing : {X : Set} → ⊥ → X
from-nothing ()
```

The function to Being throws away its input and returns the unique
inhabitant of `⊤`:

```agda
to-being : {X : Set} → X → ⊤
to-being x = tt
```

### Reads as

*From `⊥`:* "From the empty type, a function to any type `X`
exists vacuously — there is nothing to map, so every case is
handled."

*To `⊤`:* "Any term of type `X` collapses to the featureless point
of Pure Being."

## What we verified

In this chapter, Agda has checked these constructions:

- `⊤` is well-formed as a unit type with sole inhabitant `tt`.
- `⊥` is well-formed as an uninhabited type.
- `from-nothing : {X : Set} → ⊥ → X` typechecks — the principle of
  explosion is a real Agda function.
- `to-being : {X : Set} → X → ⊤` typechecks — the unique map to
  the terminal type is constructed explicitly.

## What's next

[Chapter 3](./ch03-determinate-being.md) replaces our postulates
with real proofs, introduces paths from Cubical Agda, and begins to
give the bare construction of "Becoming" real content. We will see
the first place the `--cubical` pragma earns its keep: a proof
that Pure Being is *contractible*, which is much stronger than "has
one inhabitant."
