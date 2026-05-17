# Chapter 1 — Foundations of Thought

```agda
{-# OPTIONS --cubical --guardedness #-}

module ch01-foundations where
```

## Where we are

This is the opening chapter of *Hegel's Logic in Cubical Agda*. We
start with the three most basic structural pieces of Hegel's logic —
Concepts, Judgments, and the Syllogism — and capture each via its
standard correspondent in type theory.

| Hegelian concept    | Type-theoretic correspondent |
| ------------------- | ---------------------------- |
| Concept             | Type                         |
| Judgment (`c is a C`) | Typing judgment (`c : C`)  |
| "All B are A"       | Function type (`B → A`)      |
| Syllogism           | Function composition         |

These mappings are Aristotelian — they capture the baseline Hegel
*begins from*. His distinctive moves come later. This chapter shows
the baseline working in Agda; subsequent chapters introduce what
Hegel adds to it.

## 1. Concepts (Begriffe)

### Hegelian thesis

Hegel's most fundamental unit is the **Concept** (Begriff). In the
*Doctrine of the Notion* (§1280 ff.) he treats the concept not as a
static container but as a self-developing unity of universality,
particularity, and individuality. For this opening chapter we will
work with the static "container" reading — it is what type theory
can capture cleanly — and we will signal explicitly when we are
relying on this reduction.

### In code

In Agda, the universe of all concepts is called `Set`. Despite the
name, `Set` does **not** mean "set" in the Cantor sense — it just
means "type." The naming is historical.

To make sure we have something concrete to reason about, we
*postulate* the existence of an unspecified concept. `postulate` is
Agda's keyword for "assume this exists without construction." We
use it sparingly elsewhere in this book; a few abstract starting
points are useful.

```agda
postulate
  C : Set
```

### Reads as

*"Let there be a Concept C — an unspecified type in the universe of
all types."*

## 2. Judgments (Urteile)

### Hegelian thesis

A Concept by itself is empty until something is asserted of it.
Hegel's **Judgment** (Urteil — literally *Ur-Teil*, "primal
division") is the assertion that an individual belongs to a Concept.
In the *Doctrine of the Notion* Hegel develops four kinds of
Judgment (existence, reflection, necessity, the Notion); here we
formalize only the most basic — the *typing judgment* that an
individual instantiates a concept.

This identification of philosophical Judgment with typing judgment
is the first big stretch. Hegel's Urteil has rich internal structure
that the type-theoretic correspondent flattens. We mark this as a
caveat now and develop more of the structure in later chapters.

> **Caveat:** This chapter formalizes only the *existential*
> Judgment (`c is a C`). Hegel's later Judgments of reflection,
> necessity, and the Notion (§§1641–1680) are not captured by the
> bare typing judgment.

### In code

The typing judgment in Agda is the colon. Writing `c : C` means
"`c` is a term of type `C`." We postulate one to give the chapter
something to reason about.

```agda
postulate
  c : C
```

### Reads as

*"The individual `c` is asserted to belong to the concept `C`."*

## 3. The Universal Judgment ("All B are A")

### Hegelian thesis

Concepts relate to each other. The simplest relation is universal
subsumption: "All Humans are Mortal." Hegel discusses this in the
section on the *Judgment of Existence* (§§1671 ff.) where the form
"All B are A" appears as one of the first relations Concepts can
enter into.

### In code

In Agda this is the **function type**. A function `f : B → A` is a
rule that, given any term of type `B`, produces a term of type `A`.
So "all B are A" becomes "there is a function from B to A" — every
B can be transformed into (or revealed to be) an A.

```agda
postulate
  A : Set
  B : Set
  f : B → A
```

### Reads as

*"Two concepts `A` and `B`, and a rule `f` assigning each individual
of `B` a corresponding individual of `A` — that is, 'all `B` are
`A`'."*

## 4. The Syllogism (Schluss)

### Hegelian thesis

Hegel argues that isolated Judgments are incomplete: they cry out
for connection through a mediating middle term. This is the
**Syllogism** (Schluss — "closing" or "conclusion"). The classical
example:

> "All Humans are Mortal. Socrates is Human. Therefore Socrates is
> Mortal."

Three concepts (Mortal, Human, Socrates); the middle term (Human)
links the other two. In the *Doctrine of the Notion* (§§1436 ff.)
Hegel surveys three kinds of Syllogism and argues that the
Aristotelian form is structurally inadequate. We capture the
Aristotelian form here as a baseline; the deeper moves come later.

### Math

In categorical terms, the Aristotelian syllogism is **composition
of functions**. Given `f : B → A` and `b : E → B`, the composite
`f ∘ b : E → A` *is* the syllogism's conclusion. The Curry-Howard
correspondence identifies this with the natural-deduction rule of
modus ponens applied transitively.

### In code

```agda
postulate
  E : Set       -- An individual concept (e.g., Socrates)
  b : E → B     -- "All E are B" (e.g., "Socrates is Human")
```

We now write our first Agda **program**. Unlike `postulate`, which
merely asserts, this provides an explicit construction. The `=`
gives the definition; `λ` is "lambda" — Agda's way of introducing
a function by saying "given an input named `e`, return ...":

```agda
syllogism : E → A
syllogism = λ e → f (b e)
```

The construction reads step by step:

1. We want to produce a term of type `E → A`.
2. `λ e →` introduces a placeholder `e` of type `E`.
3. `b e` applies our hypothesis `b`, yielding a term of type `B`.
4. `f (...)` applies `f` to that, yielding a term of type `A`.
5. The composite is the function we sought. Agda verifies the types
   at every step.

### Reads as

*"To produce an `A` from any `E`: take `e`, apply `b` to reveal it
as a `B`, then apply `f` to that `B` to arrive at an `A`."*

## What we verified

In this chapter, Agda has checked these constructions:

- `syllogism : E → A` exists, derived from `f : B → A` and `b : E → B`
  by function composition.

The other declarations (`C`, `c`, `A`, `B`, `f`, `E`, `b`) are
postulates — assumed, not verified. We use postulates here only to
have abstract starting points; subsequent chapters drop postulates
in favour of real proofs.

## What's next

[Chapter 2](./ch02-being.md) introduces **Pure Being** (das Sein)
and **Pure Nothing** (das Nichts) — the absolute starting point of
the *Science of Logic* — and the first dialectical move (Becoming,
das Werden). We will see why Hegel insists these two seemingly
opposite concepts collapse into each other, and how we begin to
represent that collapse in Agda.
