# Chapter 6 — Actuality

```agda
{-# OPTIONS --cubical --guardedness #-}

module ch06-actuality where

open import Cubical.Core.Primitives
open import Cubical.Foundations.Prelude using (refl)
open import ch02-being
open import ch05-essence
```

## Where we are

[Chapter 5](./ch05-essence.md) introduced the **Doctrine of
Essence**: `isProp`, the type `Ω` of all propositions, and
**Reflection** as a characteristic map `X → Ω`. We asked *"what
is essential?"* and gathered the answers into a register of
essences.

This chapter moves to Hegel's **Doctrine of Actuality**
(*Wirklichkeit*). At §1191 of the *Science of Logic* Hegel
treats modality as a trio — **Possibility**, **Actuality**,
**Necessity** — each the truth of the last. Following the
Lawvere/nLab reading, this trio corresponds to an **adjoint
triple** of base-change operations in dependent type theory:
`Σ ⊣ W ⊣ Π`. Modality is not a single operator but a structured
chain of three.

| Hegel              | Type theory      | Adjunction position |
| ------------------ | ---------------- | ------------------- |
| Possibility        | `Σ`              | left adjoint        |
| Actuality          | weakening (`W*`) | middle term         |
| Necessity          | `Π`              | right adjoint       |

We construct each of the three operations, prove the two
adjunctions with their inverse maps, and link back to
[Chapter 5](./ch05-essence.md) by showing that `Π`
**preserves propositionhood** — the universe of essences is
closed under necessitation.

## 1. Actuality as weakening (Truth in a Context)

### Hegelian thesis

Hegel's **Actuality** ([*Wirklichkeit*](./glossary.md#wirklichkeit-actuality)) places a truth into a
concrete context. A truth that is *actual* is not an abstract
or floating proposition — it is one that holds *here*, at every
point of the situation in which we find ourselves. Actuality is
the way an unconditioned truth descends into a context and
becomes a constant feature of it.

Type-theoretically, this is **weakening**: taking a value that
does not depend on a context `A` and viewing it as a constant
family over `A`. The value is the same at every point of `A`,
but it is now read *as inhabiting that context*.

### In code

```agda
weaken : {A C : Set} → C → (A → C)
weaken c = λ a → c
```

### Reads as

*"If `C` holds absolutely, then `C` holds at every point of
`A`."*

## 2. Possibility (`Σ`, left adjoint to weakening)

### Hegelian thesis

Hegel's **Possibility** ([*Möglichkeit*](./glossary.md#möglichkeit-possibility)) is the modality of mere
existence-at-some-point: a concept holds *possibly* in a
context `A` when there is **at least one** point of `A` at
which it holds. It is the weakest of the three modalities — to
be possible is only to be witnessed somewhere, not everywhere,
and not yet to be *placed* in the situation as actuality is.

### Math

In dependent type theory this is the **[dependent sum](./cubical-primitives.md#dependent-pairs-σ-__-fst-snd)** `Σ A B`:
a pair of a witness `a : A` together with a proof of `B a`. To
inhabit `Σ A B` is to exhibit *some* `a` that makes `B a` true.

`Σ` is **left adjoint** to weakening. The adjunction is the
equivalence

```text
(Σ A B → C) ≃ ((a : A) → B a → C)
```

A function from "there exists an `a` with `B a`" *to* `C` is
the same data as a function "for every `a`, `B a` implies `C`."
The two sides of the bijection convert between an existential
*input* and a universal *parametrisation*.

### In code

```agda
possibility-forward : {A C : Set} {B : A → Set}
                    → (Σ A B → C) → ((a : A) → B a → C)
possibility-forward f = λ a b → f (a , b)

possibility-backward : {A C : Set} {B : A → Set}
                     → ((a : A) → B a → C) → (Σ A B → C)
possibility-backward g = λ p → g (p .fst) (p .snd)

possibility-fwd-bwd : {A C : Set} {B : A → Set} (g : (a : A) → B a → C)
                    → possibility-forward (possibility-backward g) ≡ g
possibility-fwd-bwd g = λ i → g

possibility-bwd-fwd : {A C : Set} {B : A → Set} (f : Σ A B → C)
                    → possibility-backward (possibility-forward f) ≡ f
possibility-bwd-fwd f = λ i → f
```

Both compositions reduce judgmentally to the identity, so the
constant cubical path `λ i → ...` witnesses each inverse law.

### Reads as

*"Mapping out of an existential is the same data as universally
consuming both the witness and its proof."*

*"Conversely, a function handling every `(a, b)` pair assembles
into a function out of the `Σ`-type."*

## 3. Necessity (`Π`, right adjoint to weakening)

### Hegelian thesis

Hegel's **Necessity** ([*Notwendigkeit*](./glossary.md#notwendigkeit-necessity)) is the strongest of the
three modalities: a concept holds *necessarily* in a context
`A` when it holds at **every** point of `A`. Necessity does not
merely witness; it covers — there is no point of the context
that escapes the truth.

### Math

In dependent type theory this is the **dependent product**
`(a : A) → B a`, sometimes written `Π A B`. To inhabit it is to
give, for each `a : A`, a proof of `B a`.

`Π` is **right adjoint** to weakening. The adjunction is

```text
((a : A) → C → B a) ≃ (C → (a : A) → B a)
```

A family of functions `C → B a` (one per `a`) is the same data
as a single function from `C` into the dependent product.

### In code

```agda
necessity-forward : {A C : Set} {B : A → Set}
                  → ((a : A) → C → B a) → (C → ((a : A) → B a))
necessity-forward f = λ c a → f a c

necessity-backward : {A C : Set} {B : A → Set}
                   → (C → ((a : A) → B a)) → ((a : A) → C → B a)
necessity-backward g = λ a c → g c a

necessity-fwd-bwd : {A C : Set} {B : A → Set} (g : C → ((a : A) → B a))
                  → necessity-forward (necessity-backward g) ≡ g
necessity-fwd-bwd g = λ i → g

necessity-bwd-fwd : {A C : Set} {B : A → Set} (f : (a : A) → C → B a)
                  → necessity-backward (necessity-forward f) ≡ f
necessity-bwd-fwd f = λ i → f
```

### Reads as

*"Giving a function `C → B a` for each `a` is the same as
giving a single function `C → ∀a. B a`."*

*"The two presentations of a universal family — indexed
outside-in or inside-out — carry exactly the same data."*

## 4. Necessity preserves Essence

### Hegelian thesis

If Necessity destroyed Essence — turning essential truths into
non-essential ones — the system would be incoherent. A truth
that holds necessarily should still be *essential*: covering
every point of a context cannot manufacture spurious
internal distinctions. The doctrine of Actuality must be
compatible with the doctrine of Essence developed in
[Chapter 5](./ch05-essence.md).

### Math

**Claim.** If `B a` is a proposition for every `a : A`, then
`(a : A) → B a` is a proposition.

That is, **Necessity (`Π`) preserves Essence (propositionhood)**.
The proof is one line: at each `a`, use the proof that `B a` is
a proposition to identify any two functions pointwise.

This connects directly to [Chapter 5's
`isProp`](./ch05-essence.md#1-propositions-essential-truths).

> **Caveat:** The `Σ ⊣ W ⊣ Π` identification with Hegelian
> Possibility `⊣` Actuality `⊣` Necessity is the
> **dependent-type-theoretic analog** of modal Possibility and
> Necessity (`◊`, `□`). Classical modal logic defines those as
> unary operators on propositions; the dependent-type version
> generalises them to operators on dependent types. They
> coincide on subsingleton (propositional) types and diverge on
> richer types. The Lawvere reading takes this analogy as the
> formal residue of Hegel's distinction.

### In code

```agda
Π-preserves-prop : {A : Set} {B : A → Set}
                 → ((a : A) → isProp (B a))
                 → isProp ((a : A) → B a)
Π-preserves-prop B-prop f g = λ i a → B-prop a (f a) (g a) i
```

### Reads as

*"If `B a` is essentially-without-distinction for every `a`,
then any two universal proofs `(a : A) → B a` are themselves
essentially identified — pointwise, at each `a`."*

## What we verified

In this chapter, Agda has checked these constructions:

- `weaken : {A C : Set} → C → (A → C)` — Actuality as constant
  families.
- Four `possibility-*` terms with both inverse proofs — the
  `Σ ⊣ W` adjunction, fully witnessed.
- Four `necessity-*` terms with both inverse proofs — the
  `W ⊣ Π` adjunction, fully witnessed.
- `Π-preserves-prop` — the cross-chapter bridge: Necessity
  preserves Essence.

## What we built / what we did not build

### What we built (across six chapters)

- **The basics:** Concepts as types, Judgments as typing,
  Syllogism as composition ([Chapter 1](./ch01-foundations.md)).
- **Logic of Being:** Pure Being (`⊤`) and Pure Nothing (`⊥`),
  the bare arrows for Becoming ([Chapter 2](./ch02-being.md)).
- **Cubical Determinate Being:** contractibility of `⊤`, the
  curry/uncurry adjunction, the negation modality
  ([Chapter 3](./ch03-determinate-being.md)).
- **Unity and Aufhebung:** `Sein ≡ Nichts` via HIT, Moments and
  Co-Moments with laws, Unity of Opposites, the initial
  opposition `∅ ⊣ *` built and verified
  ([Chapter 4](./ch04-unity-aufhebung.md)).
- **Logic of Essence:** Propositions, `Ω` as classifier of
  essences, Reflection as characteristic map `X → Ω`
  ([Chapter 5](./ch05-essence.md)).
- **Actuality:** the `Σ ⊣ W ⊣ Π` adjoint triple, with `Π`
  preserving propositionhood (this chapter).

### What we did **not** build (deferred)

- A non-trivial **Aufhebung** instance (the Chapter 4 record is
  defined but uninhabited).
- The Doctrine of **Quality vs. Quantity** (the Lawvere
  program's differential cohesion).
- The Doctrine of the **Notion** proper — universality,
  particularity, individuality as a unity.
- Actual *use* of the `werden` path from Chapter 4 — e.g.,
  transporting a function defined on `being` to one defined on
  `nothing` and observing the result.

These are projects for further chapters. The present book is a
foundation that can be extended in any of these directions, and
the structure laid down here — concepts as types, modalities as
adjoints, essences as propositions — is meant to make those
extensions natural rather than forced.
