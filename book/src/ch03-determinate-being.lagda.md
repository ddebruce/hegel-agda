# Chapter 3 — Determinate Being

```agda
{-# OPTIONS --cubical --guardedness #-}

module ch03-determinate-being where

open import ch02-being
open import Cubical.Core.Primitives
```

## Where we are

[Chapter 2](./ch02-being.md) set up Pure Being (`⊤`), Pure Nothing
(`⊥`), and the bare arrows `⊥ → X` and `X → ⊤` that gave a first,
weak gesture at Becoming. Every nontrivial claim in that chapter
was a `postulate` or a one-line definition — nothing we constructed
required Cubical Agda's machinery.

This chapter moves from **asserted by postulate** to **verified by
proof**, and introduces our first genuinely Cubical content. We
produce three concrete results, each genuinely checked by Agda:

1. `⊤` is *contractible* — strictly stronger than "has one
   inhabitant," and the first place we use a path explicitly.
2. The curry/uncurry adjunction `(A × B → C) ≃ (A → B → C)` — our
   first non-trivial adjunction, witnessed by explicit programs.
3. The unit of double negation `X → ¬¬X` — the first concrete
   example of a *modal operator*, foreshadowing the `Moment`
   record of Chapter 4.

## Prelude: Cubical primitives

> Cubical Agda extends Agda with primitives from Cubical Type Theory.
> We import them from the official cubical library. Detailed
> reference: [Cubical primitives](./cubical-primitives.md).
>
> The key import is `Cubical.Core.Primitives`, which gives us:
>
> - `_≡_` — the path/equality type
> - `refl` — the constant path, witnessing `x ≡ x`
> - `PathP` — dependent paths (used internally)
> - `Σ`, `_,_` — dependent pairs

In Cubical Type Theory, `x ≡ y` is *not* a static fact but a **path**
between `x` and `y` in a type viewed as a space. A path is a function
from the unit interval `I = [i0, i1]` into the type, with endpoints
`x` and `y`. The syntax `λ i → ...` defines a path by giving its
value at each point `i` of the interval. `Σ` and its constructor
`_,_` come transitively from `Agda.Builtin.Sigma` via the cubical
library, so no local redefinition is needed.

## 1. Pure Being is Contractible

### Hegelian thesis

Hegel emphasizes throughout the opening of the *Science of Logic*
that Pure Being has **no internal distinction**: no content, no
qualities, no relation, no movement of its own. It is pure
self-identity, undifferentiated from itself in every respect.

Chapter 2 captured the *one-inhabitant* aspect of this with `⊤`,
but mere singleness is too weak. A type with one inhabitant only
says `x = y` for any two points. Hegel's claim is stronger: there
is no distinguishable structure *at any level*. The right formal
correspondent is **contractibility** — pure self-identity all the
way up.

### Math

A type `A` is **contractible** when there is a **centre** point
`x : A` such that every other point `y` has a path to `x`. Path
equality means: any two inhabitants are identified — and because
paths between paths are themselves data in Cubical Type Theory,
contractibility says these higher-order identifications are also
connected, and so on indefinitely up the homotopy hierarchy.

A set with one element merely satisfies `x = y`. A contractible
type additionally satisfies that all paths between its points are
themselves connected, paths between those paths are connected, and
so on. Contractibility is therefore *strictly stronger* than "has
one inhabitant."

### In code

The definition uses `Σ` to package a centre together with the
contraction proof:

```agda
isContr : Set → Set
isContr A = Σ A (λ x → (∀ y → x ≡ y))
```

For `⊤`, the centre is `tt`. Because records with one constructor
enjoy automatic eta-equality, any `y : ⊤` is judgmentally equal
to `tt`, so the constant path `λ i → tt` witnesses `tt ≡ y`:

```agda
⊤-is-contractible : isContr ⊤
⊤-is-contractible = (tt , λ y → (λ i → tt))
```

### Reads as

*"Pure Being is contractible: its centre is `tt`, and any other
inhabitant is identified with `tt` by the constant path."*

## 2. A real categorical adjunction (Product ⊣ Exponential)

### Math

An **adjunction** in category theory is a precise sense in which
two operations are "inverse up to isomorphism." Hegel uses *unity
of opposites* for a related move in philosophy; we will formalize
that connection in [Chapter 4](./ch04-unity-aufhebung.md).

The **currying** isomorphism is the most famous adjunction in
logic. It says: a function on pairs `A × B → C` is "the same data"
as a function `A → B → C` that expects its arguments one at a
time. This is our first non-trivial adjunction — the
cartesian-closed structure of types — and it foreshadows the
broader "unity of opposites = adjunction" theme developed in the
next chapter.

### In code

First, a minimal pair type. (Cubical's library has a richer one;
this minimal version is for clarity.)

```agda
record _×_ (A B : Set) : Set where
  constructor _,_
  field
    fst : A
    snd : B

curry : {A B C : Set} → (A × B → C) → (A → B → C)
curry f = λ a b → f (a , b)

uncurry : {A B C : Set} → (A → B → C) → (A × B → C)
uncurry f = λ p → f (p ._×_.fst) (p ._×_.snd)
```

These two functions witness the adjunction `(- × B) ⊣ (B → -)`.
They are not postulates: they are explicit programs that Agda
compiles and that perfectly invert each other.

### Reads as

*"Functions on pairs and functions taking arguments one at a time
are interchangeable."*

## 3. Negation and the double negation modality

### Hegelian thesis

Negation is structural in Hegel: the determinate emerges from
Pure Being by being marked off against what it is *not*. And the
"**negation of the negation**" is the engine of dialectic itself —
the move by which a determination, by being negated and that
negation in turn negated, returns to itself enriched.

We cannot yet model the full dialectical movement, but we can
formalize the *operator* that double negation describes. Modelling
"`X` and not-not-`X` are related but not identical" is exactly the
intuitionistic situation, and exactly the right preparation for
the modal-operator pattern Chapter 4 will generalize.

### Math

In intuitionistic type theory, to **negate** `X` means to prove
`X → ⊥`: a function that, given any `X`, produces a contradiction.
**Double negation** is `¬ (¬ X)`. Constructively, `X → ¬¬X`
always holds, but `¬¬X → X` does **not** — that direction is the
Law of Excluded Middle, which we do not assume.

The functor `¬¬` is our first concrete **modal operator**: an
operation on types that captures a quality (here, "not-not-X-ness")
which classically coincides with `X` but intuitionistically is
strictly weaker. The form `X → ◯ X` for a functor `◯` is exactly
the shape of a **monadic unit**, and Chapter 4 will abstract this
pattern into a `Moment` record.

### In code

```agda
¬_ : Set → Set
¬ X = X → ⊥

double-negation-unit : {X : Set} → X → ¬ (¬ X)
double-negation-unit x = λ f → f x
```

### Reads as

*"From any `x` of `X`, we produce a refutation of the refutation
of `X` — by applying the supposed refutation to `x` itself."*

## What we verified

In this chapter, Agda has checked these constructions:

- `⊤-is-contractible : isContr ⊤` — a real Cubical proof (no
  postulate) that Pure Being has no internal distinction at any
  level.
- `curry` and `uncurry` — explicit programs witnessing the
  product/exponential adjunction `(- × B) ⊣ (B → -)`.
- `double-negation-unit : {X : Set} → X → ¬ ¬ X` — concrete
  construction of the η of the double-negation modality.

## What's next

[Chapter 4](./ch04-unity-aufhebung.md) puts the pieces together
and makes the central Hegelian move available formally. It will:

- Use a **Higher Inductive Type** to identify Sein and Nichts —
  the strongest formal expression of Hegel's claim that *Sein*
  and *Nichts* are identical *in their truth*.
- Generalize the modal-operator pattern of double negation into a
  `Moment` record with full coherence laws.
- Define **Unity of Opposites** as an adjunction, with explicit
  inverse proofs.
- Construct the initial opposition `∅ ⊣ *` as a verified instance
  of Unity of Opposites.
