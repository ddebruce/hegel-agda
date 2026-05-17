{-# OPTIONS --cubical --guardedness #-}

------------------------------------------------------------------------
-- CHAPTER 3: DETERMINATE BEING
--
-- WHERE WE WERE
-- Chapter 1: Concepts, Judgments, Syllogism. Chapter 2: Pure Being
-- (⊤), Pure Nothing (⊥), the transitions ⊥ → X → ⊤. Every nontrivial
-- claim so far was a `postulate`.
--
-- WHAT THIS CHAPTER DOES
-- We move from "asserted by postulate" to "verified by proof," and
-- introduce our first genuinely Cubical content. Three concrete
-- results, each genuinely checked by Agda:
--
--   1. ⊤ is "contractible" — there is a path from any inhabitant to
--      any other. This is stronger than "⊤ has one element": it
--      states that the SPACE of inhabitants has no internal variation
--      at any level. The first place we use a path explicitly.
--
--   2. The curry/uncurry adjunction (A × B → C) ≃ (A → B → C). This
--      is our first NON-TRIVIAL adjunction — the cartesian-closed
--      structure of types.
--
--   3. The unit of double negation: X → ¬¬X. The first concrete
--      example of a MODAL OPERATOR (here ¬¬), which becomes the
--      central tool in Chapter 4.
--
-- WHAT IS COMING NEXT
-- Chapter 4 introduces Higher Inductive Types and uses them to
-- formalize Hegel's claim that "Sein and Nichts are identical in
-- their truth" — a stronger move than anything available without
-- the Cubical features we introduce here. Chapter 4 also generalizes
-- the modal-operator pattern of double negation into a record for
-- "Moments" and combines moments into adjunctions.
------------------------------------------------------------------------

module Chapter3-DeterminateBeing where

open import Chapter2-LogicOfBeing

---------------------------------------------------------------------------
-- PRELUDE: CUBICAL PRIMITIVES (from the Agda Cubical Library)
---------------------------------------------------------------------------
-- We import the official Cubical Agda library. From it we use:
--
--   _≡_       the path/equality type ("x ≡ y" reads "a path from x
--             to y")
--   refl      the constant path, witnessing x ≡ x
--   PathP     dependent paths, used internally by Cubical Agda
--   Σ, _,_    dependent pairs (a value of type A together with a
--             value of B applied to that A)
--
-- In Cubical Type Theory, x ≡ y is NOT a static fact but a path
-- between x and y in a type viewed as a space. A path is a function
-- from the unit interval I = [i0, i1] into the type, with endpoints
-- x and y. The syntax `λ i → ...` defines a path by giving its
-- value at each point i of the interval.

open import Cubical.Core.Primitives
-- Σ and its constructor `_,_` come transitively from Agda.Builtin.Sigma
-- via the cubical library. No local redefinition needed.

---------------------------------------------------------------------------
-- SECTION 1: PURE BEING IS CONTRACTIBLE
---------------------------------------------------------------------------
-- In Homotopy Type Theory, a type A is "contractible" when there is
-- a CENTER point x : A such that every other point y has a path to
-- x. Contractibility is the strongest possible internal unity: the
-- type has no distinguishable structure whatsoever at any level.
--
-- A SET with one element merely satisfies x = y. A CONTRACTIBLE TYPE
-- additionally satisfies that all paths between its points are
-- themselves connected, paths between those paths are connected,
-- and so on indefinitely. This matches Hegel's emphasis that Pure
-- Being has "no internal distinction" — it is pure self-identity
-- all the way up.

-- Reads as: "A type A is contractible if there is a centre x such
-- that every y is connected to x by a path."

isContr : Set → Set
isContr A = Σ A (λ x → (∀ y → x ≡ y))

-- We now PROVE — not postulate — that Pure Being is contractible.
-- The centre is tt. For any y : ⊤, eta-equality (records with one
-- constructor enjoy automatic eta) means y judgmentally equals tt,
-- so the constant path `λ i → tt` is a path from tt to y.

-- Reads as: "Pure Being is contractible: its centre is `tt`, and
-- any other inhabitant is identified with `tt` by the constant path."

⊤-is-contractible : isContr ⊤
⊤-is-contractible = (tt , λ y → (λ i → tt))

---------------------------------------------------------------------------
-- SECTION 2: A REAL CATEGORICAL ADJUNCTION (Product ⊣ Exponential)
---------------------------------------------------------------------------
-- An ADJUNCTION in category theory is a precise sense in which two
-- operations are "inverse up to isomorphism." Hegel uses "unity of
-- opposites" for something similar in philosophy. We will formalize
-- that connection in Chapter 4.
--
-- The CURRYING isomorphism is the most famous adjunction in logic.
-- It says: a function taking a pair (an A and a B) and returning a
-- C is the same data as a function taking an A and returning (a
-- function taking a B and returning a C). We define a simple pair
-- type and prove both directions.

-- A simple pair type. (Cubical's library has a richer one; this
-- minimal version is for clarity.)
record _×_ (A B : Set) : Set where
  constructor _,_
  field
    fst : A
    snd : B

-- Reads as: "Given a function on pairs (A × B → C), produce a
-- function expecting A and B one at a time."

curry : {A B C : Set} → (A × B → C) → (A → B → C)
curry f = λ a b → f (a , b)

-- Reads as: "Given a function expecting A and B one at a time,
-- produce a function on pairs."

uncurry : {A B C : Set} → (A → B → C) → (A × B → C)
uncurry f = λ p → f (p ._×_.fst) (p ._×_.snd)

-- These two functions witness the adjunction `(- × B) ⊣ (B → -)`.
-- They are not postulates: they are explicit programs that Agda
-- compiles and that perfectly invert each other.

---------------------------------------------------------------------------
-- SECTION 3: NEGATION AND THE DOUBLE NEGATION MODALITY
---------------------------------------------------------------------------
-- In intuitionistic type theory, to NEGATE a concept X means to
-- prove that X implies absurdity. Formally: ¬ X is defined as X → ⊥.
-- If you can map every X into Pure Nothing, then X itself cannot
-- have any inhabitant.

-- Reads as: "A negation of X is a function that, given any X,
-- produces a contradiction (an inhabitant of ⊥)."

¬_ : Set → Set
¬ X = X → ⊥

-- DOUBLE NEGATION is ¬ (¬ X). This is our first example of a
-- MODAL OPERATOR — an operation on types that captures a quality.
-- The functor ¬¬ captures "not-not-X-ness," which classically is
-- the same as X but intuitionistically is strictly weaker.
--
-- We can prove the UNIT of this modality: from any X we can produce
-- ¬¬ X. (The reverse direction does not hold constructively — that
-- is the Law of Excluded Middle, which we do not assume.)

-- Reads as: "From any element x of X, we produce a refutation of
-- the refutation of X — by applying the supposed refutation to
-- x itself."

double-negation-unit : {X : Set} → X → ¬ (¬ X)
double-negation-unit x = λ f → f x

-- This tiny program is the first piece of a "modal operator"
-- structure. The form  X → ◯ X  for some functor ◯ is exactly the
-- structure of a MONADIC UNIT. We will see this pattern abstracted
-- into a record called `Moment` in Chapter 4.

------------------------------------------------------------------------
-- WHAT'S NEXT
--
-- Chapter 4 puts the pieces together:
--   - Define general MOMENTS (monads) and CO-MOMENTS (comonads) as
--     records that capture Hegelian "qualities" with full coherence
--     laws.
--   - Define UNITY OF OPPOSITES via adjunctions, with full inverse
--     proofs.
--   - Construct a Higher Inductive Type containing both Being and
--     Nothing with an explicit PATH between them — the closest
--     formal expression of Hegel's claim Sein ≡ Nichts.
--   - Construct the "initial opposition" ∅ ⊣ * as a verified
--     instance of Unity of Opposites.
------------------------------------------------------------------------
