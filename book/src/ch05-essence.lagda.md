# Chapter 5 — The Logic of Essence

```agda
{-# OPTIONS --cubical --guardedness #-}

module ch05-essence where

open import Cubical.Core.Primitives
open import ch02-being
```

## Where we are

Chapters 1–4 covered the **Doctrine of Being**: Concepts, Pure
Being (`⊤`), Pure Nothing (`⊥`), their path-level identification
via a Higher Inductive Type, the framework of Moments and
Co-Moments, and the initial opposition `∅ ⊣ *`. Throughout, the
question driving us was *"what is there?"* — what shapes inhabit
the universe of bare types and bare arrows.

This chapter moves to Hegel's second book, the **Doctrine of
Essence** (*Wesen*). The driving question shifts: not *"what is
there?"* but *"what is essential?"* — meaning, what survives once
mere appearance (*Schein*) is set aside. We are no longer
cataloguing types; we are asking which types carry no information
beyond their truth value, and assembling those into a register of
essences.

Two type-theoretic tools do the work:

1. **`isProp`** — a predicate picking out the types where any two
   inhabitants are connected by a path. These are the "essential"
   types: they discard all internal variation.
2. **`Ω`** — the type of all propositions, the
   "register of essences." Topos-theoretically this is the
   *subobject classifier*; here it is also our home for
   **Reflection**, characteristic maps `X → Ω`.

## 1. Propositions (Essential Truths)

### Hegelian thesis

In the *Doctrine of Essence*, Hegel contrasts **essence**
([*Wesen*](./glossary.md#wesen-essence)) with **appearance** ([*Schein*](./glossary.md#schein-illusory-being-appearance)). At §818 he frames
essence as what is left when mere appearance is set aside —
the truth of being that has *gone into itself*, no longer
scattered across surface qualities but gathered into a
self-relation. A concept's essence is what remains invariant
when all its accidental differences are quotiented out.

Type-theoretically, this is exactly what `isProp` captures: a
type is a proposition when its internal variation has been
collapsed, so any two inhabitants are equally good — *the type
carries nothing beyond its mere being-true*.

### Math

In Homotopy Type Theory, a type `A` is a **proposition** when any
two of its inhabitants are connected by a path. This means `A`
has at most one "way to be true" — it carries no information
beyond its truth value.

- [`⊤`](./ch02-being.md#1-pure-being-das-sein) is a proposition: it has exactly one inhabitant, trivially
  identified with itself.
- [`⊥`](./ch02-being.md#2-pure-nothing-das-nichts) is a proposition: it has no inhabitants at all, so the
  identification is vacuous.
- `Bool` (the type with two distinct inhabitants `true` and
  `false`) is **not** a proposition: there is no path between
  `true` and `false`.

Propositions are the "essential" types: their internal structure
has been discarded in favour of pure truth value.

### In code

```agda
isProp : Set → Set
isProp A = (x y : A) → x ≡ y

⊤-is-prop : isProp ⊤
⊤-is-prop x y = λ i → tt

⊥-is-prop : isProp ⊥
⊥-is-prop ()
```

### Reads as

*"A type `A` is a proposition when any two of its elements are
connected by a path."*

*"Pure Being is essentially without distinction: any two of its
points are identified — eta-equality makes both judgmentally
equal to `tt`, so the constant path `λ i → tt` connects them."*

*"Pure Nothing is essentially without distinction vacuously:
there are no inhabitants whose distinction could arise, and the
absurd pattern handles the (impossible) input."*

## 2. Ω, the type of propositions

### Hegelian thesis

For Hegel, essence is not something hidden behind appearance — it
is **reflection within itself** (§816, §834). Essence appears
*as* appearance to itself: it is the movement by which a concept
returns into itself from its surface determinations and recognises
those determinations as *its own*. The universe of essences is
therefore not a remote interior; it is the structured space in
which each concept finds its truth.

Mathematically, we model that structured space as `Ω`: the type
whose inhabitants are precisely the propositions, each paired
with its certificate of being-essential.

> **Caveat:** `Ω` collects only the proposition-level "essences."
> It is *not* the full type universe `Type`. The Lawvere/nLab
> reading of Hegel's "essence as reflection within itself"
> usually points at the full type universe (made reflective by
> univalence). Here we capture the proposition-level fragment of
> that — mathematically cleaner, and what we actually need for
> this chapter's purposes.

### Math

`Ω` (also written `hProp`, for "homotopy proposition") is the
type of all propositions. An inhabitant of `Ω` is a pair: a type,
together with a proof that the type is a proposition.

`Ω` lives in `Set₁` because its inhabitants are pairs whose first
component is itself a `Set`. (A type whose values include types
must live one universe level up.)

Topos-theoretically, `Ω` is the **subobject classifier**: every
"subset" of a type `X` corresponds to a function `X → Ω` giving
the characteristic predicate for membership. This is the role we
exercise in Section 3.

### In code

```agda
record Ω : Set₁ where
  constructor prop
  field
    carrier : Set
    essence : isProp carrier

True-Essence : Ω
True-Essence = prop ⊤ ⊤-is-prop

False-Essence : Ω
False-Essence = prop ⊥ ⊥-is-prop
```

### Reads as

*"`Ω` contains, for each `carrier` type, a proof that the carrier
is a proposition. Inhabiting `Ω` is being-essential."*

## 3. Reflection (Characteristic maps)

### Hegelian thesis

Hegel's **Reflection** ([*Reflexion*](./glossary.md#reflexion-reflection)) is a concept's appearance
within the universe of essences — the act by which a concept
shows itself in the register of what is essential. A reflection
does not invent its content; it sorts the elements of its domain
into their essential truths, recognising which inhabit which
essence.

Mathematically a Reflection is a function `X → Ω` assigning each
`x` its essential truth. Equivalently, a Reflection is a *subset*
of `X` (the elements mapping to `True-Essence`) together with the
characteristic information that says, for each `x`, *how* it
belongs.

### In code

```agda
Reflection : Set → Set₁
Reflection X = X → Ω

all-true : {X : Set} → Reflection X
all-true x = True-Essence

data Bool : Set where
  true  : Bool
  false : Bool

bool-reflect : Reflection Bool
bool-reflect true  = True-Essence
bool-reflect false = False-Essence
```

### Reads as

*"A Reflection on `X` is a rule assigning each `x : X` to an
essence (a proposition in `Ω`)."*

`all-true` is the trivial Reflection: every element is
unconditionally essential, and `Ω`'s classifying role is not
exercised. `bool-reflect` is the canonical non-trivial example:
it distinguishes `true` from `false` as characteristic of two
different essences, and so actually uses `Ω` as a classifier
rather than as a placeholder.

## What we verified

In this chapter, Agda has checked these constructions:

- `isProp : Set → Set` defines the predicate "any two inhabitants
  are path-equal."
- `⊤-is-prop : isProp ⊤` — Pure Being is essentially without
  distinction.
- `⊥-is-prop : isProp ⊥` — Pure Nothing is essentially without
  distinction, vacuously.
- `Ω : Set₁` is declared as a record with `carrier : Set` and
  `essence : isProp carrier`.
- `True-Essence : Ω` and `False-Essence : Ω` populate the
  register of essences with our two canonical propositions.
- `Reflection : Set → Set₁` is defined as `X → Ω`.
- `all-true : {X : Set} → Reflection X` — the trivial Reflection
  that sends everything to `True-Essence`.
- `Bool : Set` is declared locally with two constructors `true`
  and `false`.
- `bool-reflect : Reflection Bool` — the first **non-trivial**
  Reflection, which actually exercises `Ω`'s classifier role by
  splitting `Bool` into two distinct essences.

## What's next

[Chapter 6](./ch06-actuality.md) introduces **Actuality**
(*Wirklichkeit*). Following the Lawvere/nLab reading, Hegel's
modalities of Possibility, Actuality, and Necessity correspond
to the adjoint triple `Σ ⊣ W ⊣ Π` in dependent type theory. We
construct that triple, prove the adjunctions, and link back to
this chapter with a small theorem: `Π` (Necessity) preserves
propositionhood — the universe of essences `Ω` is closed under
necessitation.
