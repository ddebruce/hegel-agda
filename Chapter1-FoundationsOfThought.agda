{-# OPTIONS --cubical --guardedness #-}

------------------------------------------------------------------------
-- A TUTORIAL: HEGEL'S LOGIC IN CUBICAL AGDA
------------------------------------------------------------------------
--
-- WHAT IS THIS PROJECT?
--
-- This is a literate Agda program that walks through fragments of
-- G.W.F. Hegel's "Science of Logic" (1812-1816), implementing them
-- inside the Cubical Agda proof assistant.
--
-- It follows a translation proposal developed by William Lawvere
-- and refined on the nLab wiki: that some moves Hegel makes in his
-- Logic can be formalized using categorical logic (adjoint functors,
-- modalities, topoi). The translation is contested; many readers of
-- Hegel doubt that consistent formal logic can capture what is most
-- distinctive about him. We try to be explicit about what we capture
-- and what we don't.
--
-- WHO IS THIS FOR?
--
-- A reader unfamiliar with either Hegel or Agda. Both are introduced
-- gradually. Hegelian terminology appears as German + English gloss
-- the first time it is used. Agda notation is explained at each new
-- construct.
--
-- WHAT IS HEGEL'S "SCIENCE OF LOGIC"?
--
-- A development of thought that starts from the most abstract category
-- possible (Pure Being) and moves through ever-more determinate
-- concepts (Something, Quality, Quantity, Essence, Actuality, Notion).
-- At each step, a concept reveals an internal tension that drives
-- transition to the next. Hegel called this method "dialectic," and
-- the resolution of a tension into a richer concept "Aufhebung"
-- (literally cancel/preserve/elevate, usually rendered "sublation").
--
-- WHAT IS AGDA?
--
-- Agda is a programming language in which the type of an expression
-- IS a proposition, and writing a program of that type IS a proof
-- of that proposition. This identification is the Curry-Howard
-- correspondence: a program of type X → Y is a proof of "X implies
-- Y" by giving an explicit construction.
--
-- WHAT IS CUBICAL AGDA?
--
-- Cubical Agda extends Agda with primitives from Cubical Type Theory.
-- Equality x ≡ y is reinterpreted as a "path" between x and y inside
-- a type viewed as a space. Types behave like ∞-groupoids: there can
-- be many paths between two points, paths between paths, and so on.
-- Two terms can be "identified by a path" without being judgmentally
-- equal. We use this from Chapter 3 onward; Chapter 1 enables the
-- pragma only for consistency with later imports.
--
-- HOW TO READ THIS BOOK
--
-- Each chapter has:
--   - A header: what was built before, what this chapter adds
--   - "Reads as:" paraphrases for each formal definition
--   - A footer pointing to the next chapter
--
-- The chapters are:
--   1. Foundations of Thought (Concepts, Judgments, Syllogism)
--   2. Logic of Being         (Pure Being, Pure Nothing, Becoming)
--   3. Determinate Being      (real proofs, basic adjunctions, ¬¬)
--   4. Unity and Aufhebung    (Sein ≡ Nichts via HIT, ∅⊣*, Moments)
--   5. Logic of Essence       (Propositions, Ω, Reflection)
--   6. Actuality              (Possibility ⊣ Actuality ⊣ Necessity)
--
------------------------------------------------------------------------

module Chapter1-FoundationsOfThought where

------------------------------------------------------------------------
-- WHAT THIS CHAPTER DOES
--
-- This chapter introduces the three most basic structural pieces of
-- Hegel's logic: Concepts (Begriffe), Judgments (Urteile), and the
-- Syllogism (Schluss). These belong to what Hegel calls the "Doctrine
-- of the Notion" — formally the last book of his system, but the
-- shape of thought we need from the start.
--
-- We capture each piece via its standard correspondent in type theory:
--
--      Hegelian concept         Type-theoretic correspondent
--      ----------------         -----------------------------
--      Concept                   Type
--      Judgment (c is a C)       Typing judgment (c : C)
--      "All B are A"             Function type (B → A)
--      Syllogism                 Function composition
--
-- This is the Aristotelian baseline Hegel begins from. Hegel argues
-- that it is inadequate by itself — concepts are not fixed boxes but
-- self-developing wholes. Later chapters introduce the moves he uses
-- to push beyond this baseline.
------------------------------------------------------------------------

---------------------------------------------------------------------------
-- SECTION 1: CONCEPTS (Begriffe)
---------------------------------------------------------------------------
-- Hegel's most fundamental unit is the Concept. In Agda, the universe
-- of all concepts is called `Set`. (Despite the name, `Set` does NOT
-- mean "set of elements" in the Cantor sense — it just means "type."
-- The naming is historical.)
--
-- To make sure we have something to reason about, we POSTULATE the
-- existence of an unspecified concept. `postulate` is Agda's keyword
-- for "assume this exists without construction." It is used sparingly
-- elsewhere in this book; a few abstract starting points are useful.

-- Reads as: "Let there be a Concept C — an unspecified type in the
-- universe of all types."

postulate
  C : Set

---------------------------------------------------------------------------
-- SECTION 2: JUDGMENTS (Urteile)
---------------------------------------------------------------------------
-- A Concept by itself is empty until something is asserted of it.
-- Hegel's "Judgment" (Urteil — literally "primal division" or
-- "Ur-Teil") is the assertion that an individual belongs to a Concept.
--
-- In Agda this is the typing judgment: writing `c : C` means "c is a
-- term of type C," i.e., "the individual c belongs to the concept C."
--
-- This identification is itself a stretch — Hegel's Urteil has a much
-- richer internal structure (judgments of existence, reflection,
-- necessity, the Notion) — but it is the closest correspondent that
-- formal logic offers.

-- Reads as: "The individual c is asserted to belong to the concept C."

postulate
  c : C

---------------------------------------------------------------------------
-- SECTION 3: THE UNIVERSAL JUDGMENT ("All B are A")
---------------------------------------------------------------------------
-- Concepts relate to each other. The simplest relation is universal
-- subsumption: "All Humans are Mortal." In Agda, this is captured by
-- the FUNCTION TYPE.
--
-- A function `f : B → A` is a rule that, given any term of type B,
-- produces a term of type A. So "All B are A" becomes "there is a
-- function from B to A" — every B can be transformed into (or
-- revealed to be) an A.

-- Reads as: "Two concepts A and B, and a rule f assigning to every
-- individual of B a corresponding individual of A — that is, 'all
-- B are A'."

postulate
  A : Set
  B : Set
  f : B → A

---------------------------------------------------------------------------
-- SECTION 4: THE SYLLOGISM (Schluss)
---------------------------------------------------------------------------
-- Hegel argues that isolated Judgments are incomplete: they cry out
-- for connection through a mediating middle term. This is the
-- "Syllogism" (Schluss — literally "closing" or "conclusion").
--
-- Classical example: "All Humans are Mortal. Socrates is Human.
-- Therefore Socrates is Mortal." Three concepts (Mortal, Human,
-- Socrates); the middle term (Human) links the other two.
--
-- In type theory this pattern is FUNCTION COMPOSITION:
--   f : B → A          ("All Humans are Mortal")
--   b : E → B          ("Socrates is Human")
--   syllogism : E → A  ("Socrates is Mortal")  =  f after b

postulate
  E : Set       -- An individual concept (e.g., Socrates)
  b : E → B     -- "All E are B" (e.g., "Socrates is Human")

-- We now write our first actual Agda PROGRAM. Unlike `postulate`,
-- which merely asserts, this provides an explicit construction.
-- The `=` gives the definition; the `λ` is "lambda" — Agda's way
-- of introducing a function by saying "given an input named e,
-- return ...".

-- Reads as: "To produce an A from any E: take e, apply b to reveal
-- it as a B, then apply f to that B to arrive at an A."

syllogism : E → A
syllogism = λ e → f (b e)

-- HOW THIS PROOF WORKS
-- 1. We want to construct a term of type E → A.
-- 2. `λ e →` introduces a placeholder e of type E.
-- 3. `b e` applies our hypothesis b, yielding a term of type B.
-- 4. `f (...)` applies f to that, yielding a term of type A.
-- 5. The composite is the function we sought. Agda verifies the
--    types at every step.
--
-- This is the Aristotelian syllogism Hegel uses as his starting
-- point. Hegel considers this form too rigid: it treats concepts as
-- fixed boxes rather than as moving, self-developing wholes. The
-- next chapters introduce the moves that push beyond it.

------------------------------------------------------------------------
-- WHAT'S NEXT
--
-- Chapter 2 introduces "Pure Being" (das Sein) and "Pure Nothing"
-- (das Nichts) — the absolute starting point of the Science of
-- Logic — and the first dialectical move (Becoming, das Werden).
-- We will see why Hegel insists these two seemingly opposite
-- concepts collapse into each other, and how we begin to represent
-- that collapse in Agda.
------------------------------------------------------------------------
