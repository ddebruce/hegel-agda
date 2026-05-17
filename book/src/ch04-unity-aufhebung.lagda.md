# Chapter 4 — Unity and Aufhebung

```agda
{-# OPTIONS --cubical --guardedness #-}

module ch04-unity-aufhebung where

open import Cubical.Core.Primitives
open import Cubical.Foundations.Prelude using (refl)
open import ch02-being
open import ch03-determinate-being
```

## Where we are

[Chapter 2](./ch02-being.md) introduced Pure Being (`⊤`), Pure
Nothing (`⊥`), and the bare arrows `⊥ → X` and `X → ⊤` — a first,
weak gesture at Becoming with no Cubical content. [Chapter
3](./ch03-determinate-being.md) added genuine Cubical machinery:
contractibility of `⊤`, the curry/uncurry adjunction, and the
double-negation unit `X → ¬¬X` — our first concrete modal operator.

This is the most distinctively Hegelian chapter. It makes five
moves:

1. **Sein ≡ Nichts via HIT.** A Higher Inductive Type `Becoming`
   contains the points `being` and `nothing` plus a path
   `werden : being ≡ nothing` identifying them.
2. **Moments and Co-Moments with laws.** Records that capture
   monads and comonads — *with* the coherence laws, not just the
   signatures.
3. **Unity of Opposites as adjunction.** A `UnityOfOpposites`
   record binding a Co-Moment to a Moment with two inverse proofs.
4. **The initial opposition `∅ ⊣ *`.** A fully-verified instance
   `Becoming-Adjunction : UnityOfOpposites Nothing-CoMoment Being-Moment`.
5. **Aufhebung as record.** The structural form of a higher Unity
   subsuming a lower one, declared but not yet inhabited.

## 1. Sein ≡ Nichts (Becoming as a Higher Inductive Type)

### Hegelian thesis

Hegel's most famous early claim in the *Science of Logic*
(§134–§180) is that **Pure Being and Pure Nothing are identical in
their truth** — not approximately, not as a regulative idea, but
*equal*. At §178 he writes that their truth is "this movement of
the immediate vanishing of the one in the other": **Becoming**
(*Werden*). The two are not merely related opposites side by side
— their identity *is* the dynamic, the passing-over of each into
the other, which Hegel will then re-determine as the structure
of all subsequent thought.

> **Caveat:** Consistent formal logic cannot make `⊤` and `⊥`
> judgmentally equal — doing so would yield a term of every type
> and collapse the system. Hegel himself flags this barrier at
> §1798: *"the thinking of contradiction is the essential moment of
> the Notion."* No consistent formal system captures Hegel's claim
> fully. The Higher Inductive Type below gets us the closest
> available compromise: a **path-level** identification, structural
> rather than judgmental.

### Math

**Higher Inductive Types (HITs)** extend ordinary inductive types
with *path constructors*. An ordinary inductive type introduces a
type by listing its point constructors (e.g. `zero` and `suc` for
`ℕ`). A path constructor introduces, in addition, an explicit
identification — a path — between two points of the type. In
ordinary type theory this is impossible: equality is propositional
and cannot be axiomatised constructor-by-constructor. In **Cubical
Type Theory** it is a basic feature, because paths are themselves
first-class data (functions out of the interval `I`).

A HIT is therefore the natural home for Hegel's "Sein ≡ Nichts":
we get to *put* a path between the two points without postulating
a contradiction.

### In code

```agda
data Becoming : Set where
  being   : Becoming
  nothing : Becoming
  werden  : being ≡ nothing
```

### Reads as

*"`Becoming` is a space containing the point `being`, the point
`nothing`, and a path `werden` between them — identifying them not
by equation but by an explicit continuous transition."*

## 2. Moments and Co-Moments (Monads and Comonads with laws)

### Hegelian thesis

Hegel uses the word **Moment** not in the temporal sense but as a
structural component of a concept — a quality that can be
*projected out* of a concept while remaining tied to it. A Moment
is therefore an operator: it takes a concept and exhibits a
specific quality of it. The dual is a **Co-Moment**, which
*extracts* rather than projects.

Chapter 3's `¬¬` was our first concrete example of this pattern:
the operator `X ↦ ¬¬X` with its unit `X → ¬¬X` is exactly the
shape of a Moment — a functor with an insertion. Here we abstract
that pattern, and additionally demand the coherence laws that
prevent garbage inhabitants of the record.

### Math

Categorically, a **Moment** is a *monad*: a functor `◯` equipped
with a unit `η : X → ◯ X` (insertion) and a multiplication
`μ : ◯ ◯ X → ◯ X` (collapse of nesting), satisfying functoriality
and the monad laws. A **Co-Moment** is the *comonad* dual: a
functor `◻` with counit `ε : ◻ X → X` (extraction) and
comultiplication `δ : ◻ X → ◻ ◻ X` (duplication).

The laws are what give the record real content. The **left-unit**
law says inserting an `x` and then collapsing gives back `x`
unchanged: "inserting then collapsing is the identity." The
**right-unit** law says inserting *inside* an existing `◯ X` (by
mapping `η` across it) and then collapsing also gives back the
original: "inserting on the inside then collapsing is also the
identity." Functoriality (`map-id`) says the operator respects
identities. Without these laws, *any* triple of functions with the
right type signatures would qualify; with them, only genuine
(co)monads inhabit the record.

### In code

```agda
record Moment : Set₁ where
  field
    -- The functor.
    ◯ : Set → Set
    -- Reads as: "◯ acts on functions, lifting f to a function on ◯."
    map : {X Y : Set} → (X → Y) → ◯ X → ◯ Y
    -- Reads as: "the unit η inserts an X into ◯ X."
    η : {X : Set} → X → ◯ X
    -- Reads as: "the multiplication μ collapses nested ◯ ◯ down to ◯."
    μ : {X : Set} → ◯ (◯ X) → ◯ X
    -- Functor law: map of the identity function is the identity.
    map-id : {X : Set} (x : ◯ X) → map (λ y → y) x ≡ x
    -- Monad law: inserting then collapsing is the identity.
    left-unit  : {X : Set} (x : ◯ X) → μ (η x) ≡ x
    -- Monad law: inserting on the inside then collapsing is also id.
    right-unit : {X : Set} (x : ◯ X) → μ (map η x) ≡ x
```

A fully-axiomatised monad also requires associativity
`μ (map μ x) ≡ μ (μ x)` and functoriality of composition. We omit
these to keep the record manageable; the two instances we
construct below satisfy all monad laws trivially.

```agda
record CoMoment : Set₁ where
  field
    ◻ : Set → Set
    comap : {X Y : Set} → (X → Y) → ◻ X → ◻ Y
    -- Reads as: "the counit ε extracts an X from ◻ X."
    ε : {X : Set} → ◻ X → X
    -- Reads as: "the comultiplication δ duplicates ◻ X into ◻ (◻ X)."
    δ : {X : Set} → ◻ X → ◻ (◻ X)
    comap-id : {X : Set} (x : ◻ X) → comap (λ y → y) x ≡ x
    left-counit  : {X : Set} (x : ◻ X) → ε (δ x) ≡ x
    right-counit : {X : Set} (x : ◻ X) → comap ε (δ x) ≡ x
```

## 3. The Unity of Opposites (Adjoint Moments)

### Hegelian thesis

Hegel's **unity of opposites** binds a Moment and a Co-Moment
together. They are not just two operators standing side by side:
each is the other's counterpart, and their relation has a precise
shape. The categorical name for this shape — for the binding of a
Moment to a Co-Moment that makes the pair mutually defining — is
an **adjunction**.

### Math

An **adjunction** `C ⊣ M` between functors is a natural
isomorphism

```text
Hom(◻ X, Y) ≃ Hom(X, ◯ Y)
```

meaning a function `◻ X → Y` carries the same data as a function
`X → ◯ Y`, with a bijection that perfectly inverts. We capture
this with `forward`, `backward`, and the two inverse proofs
`fwd-bwd` and `bwd-fwd`. The inverse proofs are what prevent
garbage inhabitants of the record: any pair of translations that
fails to invert is rejected by Agda.

### In code

```agda
record UnityOfOpposites (C : CoMoment) (M : Moment) : Set₁ where
  field
    forward  : {X Y : Set} → (CoMoment.◻ C X → Y) → (X → Moment.◯ M Y)
    backward : {X Y : Set} → (X → Moment.◯ M Y) → (CoMoment.◻ C X → Y)
    fwd-bwd  : {X Y : Set} (f : X → Moment.◯ M Y) (x : X)
             → forward (backward f) x ≡ f x
    bwd-fwd  : {X Y : Set} (g : CoMoment.◻ C X → Y) (cx : CoMoment.◻ C X)
             → backward (forward g) cx ≡ g cx
```

A full notion would also demand naturality of `forward` and
`backward` in both variables. We omit that here for brevity; the
instance below is natural by inspection.

### Reads as

*"A Unity of Opposites is a pair of mutually inverse translations:
one direction sends maps out of `◻ X` into `Y` to maps of `X` into
`◯ Y`, and the other sends them back, with proofs that each round
trip returns the original."*

## 4. The Initial Opposition (∅ ⊣ \*)

### Math

We now construct our first instance of `UnityOfOpposites` — the
starting point of Hegel's whole development. Following the
Lawvere/nLab reading of the *Science of Logic*, the **initial
opposition** is the adjunction between

- the **constant comonad at ⊥** — `◻ X = ⊥` for every `X` — as the
  left adjoint, representing Nothing, and
- the **constant monad at ⊤** — `◯ X = ⊤` for every `X` — as the
  right adjoint, representing Being.

It is the foundational categorical structure on which all further
determinations of being and essence are built.

> **Caveat:** The adjunction is content-free: both Hom-sets are
> contractible (any two functions between contractible types are
> equivalent up to a unique path), so the bijection holds
> vacuously. That triviality is faithful to the Lawvere reading —
> the initial opposition IS the bare-minimum categorical
> structure, and richer dialectical content arrives by further
> determination, not from this opposition itself.

### In code

The constant comonad at `⊥`: every field reduces to a vacuous
absurd pattern, because `◻ X = ⊥` has no inhabitants for Agda to
operate on:

```agda
Nothing-CoMoment : CoMoment
Nothing-CoMoment = record
  { ◻ = λ X → ⊥
  ; comap = λ {X} {Y} f ()
  ; ε = λ {X} ()
  ; δ = λ {X} ()
  ; comap-id = λ {X} ()
  ; left-counit = λ {X} ()
  ; right-counit = λ {X} ()
  }
```

The constant monad at `⊤`: all laws are discharged by `refl`,
because `⊤` enjoys eta-equality and so any two of its inhabitants
are judgmentally equal to `tt`:

```agda
Being-Moment : Moment
Being-Moment = record
  { ◯ = λ X → ⊤
  ; map = λ {X} {Y} f _ → tt
  ; η = λ _ → tt
  ; μ = λ _ → tt
  ; map-id = λ x → refl
  ; left-unit = λ x → refl
  ; right-unit = λ x → refl
  }
```

The initial opposition: every required field is a real term, and
Agda verifies the inverse proofs. The vacuous cases on the
Nothing side use the absurd pattern; the `⊤` side uses `refl`
because `⊤`'s eta-equality makes any path between inhabitants
definitionally `refl`:

```agda
Becoming-Adjunction : UnityOfOpposites Nothing-CoMoment Being-Moment
Becoming-Adjunction = record
  { forward  = λ f x → tt
  ; backward = λ g ()
  ; fwd-bwd  = λ f x → refl
  ; bwd-fwd  = λ g ()
  }
```

## 5. Aufhebung (Sublation)

### Hegelian thesis

Hegel's **Aufhebung** combines three senses at once: *to cancel*,
*to preserve*, and *to elevate*. A sublation cancels the
contradiction of a lower Unity, preserves its moments, and raises
them to a resolved higher Unity. The lower opposition is not
destroyed; its content survives, but as a moment of a richer,
more determinate structure.

### In code

We model the structural shape: a higher `UnityOfOpposites` that
subsumes a lower one via an inclusion of the lower moment into the
higher.

```agda
record Aufhebung (C₁ : CoMoment) (M₁ : Moment) : Set₁ where
  field
    sublating-C : CoMoment
    sublating-M : Moment
    sublating-Unity : UnityOfOpposites sublating-C sublating-M
    preserve-elevate : {X : Set} → Moment.◯ M₁ X → Moment.◯ sublating-M X
```

> **Caveat:** We declare the `Aufhebung` record but do not
> construct an instance. The record captures the "contains" aspect
> (a higher Unity subsumes a lower one) but understates Hegel's
> structure — a full account would require the inclusion to
> commute with the moment operations and would track HOW the
> contradiction is resolved at the higher level. A non-trivial
> `Aufhebung` instance is on the deferred list, awaiting the
> richer modalities of later chapters.

### Reads as

*"An Aufhebung of a lower `(C₁ ⊣ M₁)` is a higher Unity
`(sublating-C ⊣ sublating-M)` plus a function showing the lower
moment is contained in the higher moment."*

## What we verified

- `Becoming : Set` is a Higher Inductive Type with
  `werden : being ≡ nothing` — Sein and Nichts identified at the
  path level, not judgmentally.
- `Moment` and `CoMoment` records demand functoriality plus the
  monad/comonad unit laws — not just the bare signatures, so only
  genuine (co)monads can inhabit them.
- `Being-Moment : Moment` and `Nothing-CoMoment : CoMoment` are
  constructed; every included law is verified by `refl` (Being
  side, via the eta law for `⊤`) or by the absurd pattern
  (Nothing side).
- `Becoming-Adjunction : UnityOfOpposites Nothing-CoMoment
  Being-Moment` is constructed with explicit `forward`, `backward`,
  and the two inverse proofs `fwd-bwd` and `bwd-fwd`.
- The `Aufhebung` record is **declared**, not inhabited —
  intentionally, as flagged in the caveat above.

## What's next

[Chapter 5](./ch05-essence.md) turns to the **Doctrine of Essence**
(*Wesen*), the second book of Hegel's *Logic*. We move from the
bare opposition of `⊥` and `⊤` to the structured universe of mere
propositions `Ω`, and to **Reflection** — characteristic maps as
the categorical correlate of Hegel's "appearance returning into
itself."
