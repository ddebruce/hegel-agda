# Glossary

Hegelian terms first (alphabetised by German), then Agda terms.

## Hegelian terms

### Aufhebung (sublation)

Hegel's term for the resolution of a dialectical contradiction
into a higher concept that "cancels, preserves, and elevates"
the moments of the lower one. Combines three German senses
(aufheben can mean "lift up," "abolish," or "preserve").

Introduced in [Chapter 4](./ch04-unity-aufhebung.md).

### Begriff (Concept)

Hegel's most fundamental unit. In the *Doctrine of the Notion*
the Concept is treated as a self-developing unity of universality,
particularity, and individuality. We capture only the static
"container" reading in this book.

Introduced in [Chapter 1](./ch01-foundations.md).

### Dasein (Determinate Being)

The first concept after Pure Being and Pure Nothing have been
sublated through Becoming. Hegel's term for being-with-determination.

Discussed in [Chapter 3](./ch03-determinate-being.md).

### Möglichkeit (Possibility)

In Hegel's discussion of Actuality (§1191), one of three modal
moments. The Lawvere reading identifies Possibility with the
dependent sum `Σ`.

Introduced in [Chapter 6](./ch06-actuality.md).

### Nichts (Pure Nothing)

The categorical opposite of Pure Being. Hegel insists Pure Nothing
has the same indeterminacy as Pure Being — both lack any
qualities — which sets up the dialectical move to Becoming.
Modeled as the empty type `⊥`.

Introduced in [Chapter 2](./ch02-being.md).

### Notwendigkeit (Necessity)

The third modal moment in Hegel's discussion of Actuality. The
Lawvere reading identifies Necessity with the dependent product
`Π`.

Introduced in [Chapter 6](./ch06-actuality.md).

### Reflexion (Reflection)

In the *Doctrine of Essence*, the act of a concept appearing within
the universe of essential truths. We capture one fragment of this
as a characteristic map `X → Ω`.

Introduced in [Chapter 5](./ch05-essence.md).

### Schein (Illusory being, Appearance)

The surface appearance of a concept, distinct from its Essence
(Wesen). Hegel's *Doctrine of Essence* opens with the distinction
of Essence from Appearance.

Discussed in [Chapter 5](./ch05-essence.md).

### Schluss (Syllogism)

The connection of two Judgments through a mediating middle term.
The classical form is the Aristotelian "All B are A; E is B;
therefore E is A." We model it by function composition.

Introduced in [Chapter 1](./ch01-foundations.md).

### Sein (Pure Being)

The most abstract concept — pure existence without further
qualities. The absolute starting point of the *Science of Logic*.
Modeled as the unit type `⊤`.

Introduced in [Chapter 2](./ch02-being.md).

### Urteil (Judgment)

The assertion that an individual belongs to a Concept. Literally
"primal division" — *Ur-Teil*. We model it as the typing judgment
`c : C`.

Introduced in [Chapter 1](./ch01-foundations.md).

### Werden (Becoming)

The unity of Pure Being and Pure Nothing. Hegel's first dialectical
result: Sein and Nichts pass over into each other, and their truth
is the movement between them. Modeled in Chapter 2 by the bare
arrows `⊥ → X → ⊤`, and in Chapter 4 more strongly by a Higher
Inductive Type with an explicit path between Being and Nothing.

### Wesen (Essence)

The subject of Hegel's second book (*Doctrine of Essence*). What
survives when mere Appearance is set aside. We model fragments of
Wesen using the type `Ω` of mere propositions.

Introduced in [Chapter 5](./ch05-essence.md).

### Wirklichkeit (Actuality)

The subject of Hegel's discussion of modality (§1191). Truth placed
in a concrete context. The Lawvere reading identifies Actuality
with type-theoretic weakening (a value lifted into a context).

Introduced in [Chapter 6](./ch06-actuality.md).

## Agda terms

### `⊤` (top, unit type)

A type with exactly one inhabitant `tt`. Used to model Pure Being.

```agda
record ⊤ : Set where
  constructor tt
```

### `⊥` (bottom, empty type)

A type with no inhabitants. Used to model Pure Nothing.

```agda
data ⊥ : Set where
```

### `_≡_` (path equality)

In Cubical Agda, `x ≡ y` is a path between `x` and `y`. See the
[Cubical primitives reference](./cubical-primitives.md).

### `refl`

The reflexivity path `x ≡ x`. Identical to `λ i → x`.

### `Σ` (dependent sum)

The type of pairs `(a, b)` where `a : A` and `b : B a`. Used to
model Possibility (Chapter 6).

### `Π` (dependent product)

The dependent function type `(a : A) → B a`. Used to model
Necessity (Chapter 6).

### `Set`

Agda's universe of types. Despite the name, `Set` does not refer
to set-theoretic sets — it just means "type." The naming is
historical.

### `Set₁`

The universe of types-of-types. `Set : Set₁`. Types containing
universe-level things live one level up.

### `isContr A`

A type expressing that `A` is contractible — has a center point
connected by paths to every inhabitant. Strictly stronger than
"A has one element."

### `isProp A`

A type expressing that `A` is a proposition — any two inhabitants
are path-equal. The proposition-level fragment of Essence in
Chapter 5.

### `Ω`

The type of all propositions. Introduced in Chapter 5 as the
classifier of essential truths.

### `postulate`

Agda's keyword for "assume this exists without construction."
Used sparingly in this book for abstract starting points; later
chapters drop postulates in favor of real proofs.

### Higher Inductive Type (HIT)

A type definition that includes path constructors as well as
point constructors. Used in Chapter 4 to model Sein ≡ Nichts.

### Absurd pattern `()`

Used as the body of a function whose input type is empty. Tells
Agda there is no case to handle.
