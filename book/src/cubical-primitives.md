# Cubical primitives reference

> **Reference, not tutorial.** Skip this page on first read. Each
> chapter introduces the cubical-Agda constructs it needs in
> context and links back here for a one-page reminder. Use this
> appendix when you want the formal definition of `_≡_`, `PathP`,
> `Σ`, HITs, the unit interval, eta-equality, or absurd patterns
> — not as a prerequisite tutorial.

This page collects the Cubical Agda machinery used throughout the
book in one place. Every chapter links here on first use.

## The interval `I`

Cubical Agda has a primitive type `I` — the "unit interval." Its
inhabitants are `i0` (left endpoint) and `i1` (right endpoint),
plus a continuous family of points in between. You don't construct
elements of `I` directly; you receive them as the bound variable
of a path (see below).

## Paths and `_≡_`

In plain Agda, equality `x ≡ y` is a static proposition. In
Cubical Agda, `x ≡ y` is a **path** between `x` and `y` —
specifically, a function `I → A` whose value at `i0` is `x` and at
`i1` is `y`.

You construct a path with lambda over `I`:

```agda
constant-path : {A : Set} (x : A) → x ≡ x
constant-path x = λ i → x
```

The constant path `λ i → x` always evaluates to `x` for every `i`,
so it witnesses `x ≡ x`. This is the **reflexivity** path, also
written `refl`.

```agda
example-refl : {A : Set} (x : A) → x ≡ x
example-refl x = refl
```

`refl` and `λ i → x` are interchangeable.

## `PathP` (dependent paths)

`PathP` is the dependent version of `_≡_`: a path in a family of
types that varies along the interval. You won't construct `PathP`
directly very often, but you'll see it in type signatures generated
by Agda when paths cross type boundaries. For the purposes of
this book, treat `PathP (λ _ → A) x y` as identical to `x ≡ y`.

## Dependent pairs: `Σ`, `_,_`, `fst`, `snd`

The cubical library re-exports the builtin dependent pair type:

```agda
-- Σ has signature
Σ : (A : Set) → (A → Set) → Set

-- with constructor _,_
example : Σ ⊤ (λ _ → ⊤)
example = (tt , tt)
```

For non-dependent pairs we often define a separate `_×_` record
(as in Chapter 3) because it has nicer pattern-matching.

## Absurd patterns

When a function takes an argument of type `⊥` (the empty type),
there is nothing to define — `⊥` has no inhabitants, so the
function is "defined" vacuously. Agda's syntax for this is the
**absurd pattern** `()`:

```agda
from-nothing : {X : Set} → ⊥ → X
from-nothing ()
```

The body of the function is omitted; the `()` tells the typechecker
that no case is missing.

## Eta-equality for records

A record type with one constructor and explicit fields enjoys
**eta-equality**: any value of the record is judgmentally equal to
the constructor applied to its projections. Concretely, for the
unit type:

```agda
record ⊤ : Set where
  constructor tt
```

any `x : ⊤` is judgmentally equal to `tt`. So `λ i → tt` is a path
from `tt` to any `y : ⊤` — because `y` *is* `tt`.

## Higher Inductive Types (HITs)

Standard Agda lets you define types with **point constructors**:

```agda
data Bool : Set where
  true  : Bool
  false : Bool
```

Cubical Agda lets you also define **path constructors**:

```agda
data Becoming : Set where
  being   : Becoming
  nothing : Becoming
  werden  : being ≡ nothing
```

`werden` adds a path identifying `being` with `nothing`. This is a
*Higher Inductive Type* — "higher" because it lives at a higher
homotopical level than ordinary inductive types.

We use this in Chapter 4 to model Hegel's claim that Sein ≡ Nichts.

## The libraries

The book imports from the [agda/cubical](https://github.com/agda/cubical)
library. CI uses version 0.8 (paired with Agda 2.7.0.1); version
0.9 (paired with Agda 2.8.0) also works locally. The key modules
are:

- `Cubical.Core.Primitives` — `I`, `_≡_`, `PathP`, `Σ`, `_,_`
- `Cubical.Foundations.Prelude` — `refl`, `sym`, `_∙_`, `cong`,
  `transport`

You shouldn't need to import other cubical modules to follow this
book.
