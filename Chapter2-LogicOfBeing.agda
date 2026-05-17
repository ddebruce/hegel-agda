{-# OPTIONS --cubical --guardedness #-}

------------------------------------------------------------------------
-- CHAPTER 2: THE LOGIC OF BEING
--
-- WHERE WE WERE
-- Chapter 1 introduced Concepts (types), Judgments (typing), and
-- the Syllogism (function composition). Those Concepts were
-- postulated — we never asked "what is the simplest possible
-- Concept?"
--
-- WHAT THIS CHAPTER DOES
-- The Science of Logic begins not with the syllogism but with the
-- pair Pure Being (Sein) and Pure Nothing (Nichts). Hegel argues
-- these are equally indeterminate, and their tension gives rise to
-- Becoming (Werden). Here we set up the type-theoretic correspondents:
--
--      Hegelian concept      Type-theoretic correspondent
--      ----------------      -----------------------------
--      Pure Being            ⊤  (unit type; one inhabitant)
--      Pure Nothing          ⊥  (empty type; zero inhabitants)
--      Becoming              the obvious functions  ⊥ → X  and  X → ⊤
--
-- WHAT IS COMING NEXT
-- Chapter 3 turns these arrows from "exist trivially" into "verified
-- by proof," and introduces our first genuinely Cubical content
-- (contractibility, paths). Chapter 4 then makes the much stronger
-- move of identifying Sein and Nichts via a Higher Inductive Type.
------------------------------------------------------------------------

module Chapter2-LogicOfBeing where

---------------------------------------------------------------------------
-- SECTION 1: PURE BEING (Das Sein)
---------------------------------------------------------------------------
-- Hegel's Pure Being is the most abstract concept possible: pure
-- existence without any further qualities. To say "X is" without
-- saying anything else about X.
--
-- In type theory this corresponds to the UNIT TYPE, often written
-- ⊤ ("top"). A unit type has exactly one inhabitant, which we name
-- `tt`. The inhabitant has no internal structure, no qualities,
-- nothing to distinguish it from itself. It just is.
--
-- Agda's `record` keyword defines a type whose values are tuples of
-- fields. A record with no fields and a single constructor `tt` is
-- inhabited by exactly one value.

-- Reads as: "Pure Being ⊤ is the type whose sole inhabitant is `tt`,
-- with no further data."

record ⊤ : Set where
  constructor tt

---------------------------------------------------------------------------
-- SECTION 2: PURE NOTHING (Das Nichts)
---------------------------------------------------------------------------
-- Hegel's Pure Nothing is the categorial opposite: the concept under
-- which nothing falls.
--
-- In type theory this is the EMPTY TYPE ⊥ ("bottom"). We declare
-- it with `data` and provide NO constructors, so there is no way to
-- build a term of type ⊥. In propositions-as-types, ⊥ is the
-- proposition that is provably false.

-- Reads as: "Pure Nothing ⊥ is the type with no inhabitants whatsoever."

data ⊥ : Set where
  -- (intentionally no constructors)

---------------------------------------------------------------------------
-- SECTION 3: BECOMING (Das Werden)
---------------------------------------------------------------------------
-- Hegel's central early move: Being and Nothing are equally
-- indeterminate, so they "pass over into each other." Their truth
-- is Becoming — the movement between them.
--
-- A first, weak way to model this: any type X sits between ⊥ and ⊤,
-- because every type has a unique function from ⊥ (the principle of
-- explosion: "from nothing, anything follows") and a unique function
-- to ⊤ ("any determinate thing can be stripped to bare existence"):
--
--          ⊥ ───── from-nothing ─────▶ X ───── to-being ─────▶ ⊤
--
-- These two functions exist for trivial categorical reasons (⊥ is
-- initial, ⊤ is terminal). They carry no information by themselves.
-- Chapter 4 will refine this dramatically by introducing a single
-- type containing both Being and Nothing connected by an explicit
-- path — closer to Hegel's claim that Sein and Nichts are identical
-- in their truth. For now, just the two arrows.

-- Reads as: "From the empty type, a function to any type X exists
-- vacuously — because there is nothing to map, every case is
-- handled."

from-nothing : {X : Set} → ⊥ → X
from-nothing ()
-- The `()` is the ABSURD PATTERN. It tells Agda: "there are no
-- inhabitants of ⊥ to consider, so this function is defined
-- everywhere it needs to be defined (which is nowhere)."

-- Reads as: "Any term of type X collapses to the featureless point
-- of Pure Being."

to-being : {X : Set} → X → ⊤
to-being x = tt
-- For any input x, throw it away and return the unique inhabitant
-- of ⊤.

------------------------------------------------------------------------
-- WHAT'S NEXT
--
-- We have ⊥ and ⊤ and the obvious arrows between them. But this is
-- the BARE MINIMUM — both functions exist for trivial categorical
-- reasons. Chapter 3 replaces our postulates with real proofs,
-- introduces paths from Cubical Agda, and begins to give the bare
-- construction of "Becoming" real content (e.g., contractibility
-- of Pure Being as a stronger statement than "one inhabitant").
------------------------------------------------------------------------
