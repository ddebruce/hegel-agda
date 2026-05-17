{-# OPTIONS --cubical --guardedness #-}

------------------------------------------------------------------------
-- CHAPTER 6: ACTUALITY
--
-- WHERE WE WERE
-- Chapter 5 introduced PROPOSITIONS (isProp), the type Ω of all
-- propositions, and REFLECTION as a characteristic map X → Ω.
--
-- WHAT THIS CHAPTER DOES
-- We follow Lawvere's reading of §1191 of the Science of Logic: the
-- modalities of Possibility, Actuality, and Necessity correspond to
-- an ADJOINT TRIPLE of base-change operations in dependent type
-- theory:
--
--      Hegel              Type theory       Adjunction position
--      -----              -----------       --------------------
--      Possibility       Σ                  left adjoint
--      Actuality         weakening (A* )    middle term
--      Necessity         Π                  right adjoint
--
-- We construct each of these three operations, prove the two
-- adjunctions with their inverse maps, and link back to Chapter 5
-- by showing that Π preserves propositionhood — i.e., Necessity
-- preserves Essence.
--
-- HONEST CAVEAT
-- This is the dependent-type-theoretic ANALOG of modal Possibility
-- and Necessity (◊, □). Classical modal logic defines those as unary
-- operators on propositions; the dependent-type version generalises
-- them to operators on dependent types. They coincide on
-- subsingleton types and diverge on richer types. The Lawvere reading
-- takes this analogy as the formal residue of Hegel's distinction.
--
-- WHAT IS COMING NEXT
-- This is the end of the current book. Possible directions for
-- further chapters:
--   - a non-trivial AUFHEBUNG instance (e.g., showing the Σ/Π
--     adjunctions Aufheben the initial opposition ∅ ⊣ *)
--   - the Doctrine of Quality vs. Quantity, following the
--     differential-cohesion thread of the Lawvere program
--   - the Doctrine of the Notion proper (universality, particularity,
--     individuality as a unity)
--   - actually USING the `werden` path from Chapter 4 — e.g.,
--     transporting along it
------------------------------------------------------------------------

module Chapter6-Actuality where

open import Cubical.Core.Primitives
open import Cubical.Foundations.Prelude using (refl)
open import Chapter2-LogicOfBeing
open import Chapter5-LogicOfEssence

---------------------------------------------------------------------------
-- SECTION 1: ACTUALITY AS WEAKENING (Truth in a Context)
---------------------------------------------------------------------------
-- Hegel's "Actuality" (Wirklichkeit) places a truth into a concrete
-- context. Type-theoretically, this is WEAKENING: taking a value
-- that does not depend on a context A and viewing it as a constant
-- family over A.

-- Reads as: "If C holds absolutely, then C holds at every point of A."

weaken : {A C : Set} → C → (A → C)
weaken c = λ a → c

---------------------------------------------------------------------------
-- SECTION 2: POSSIBILITY (Σ, Left Adjoint to Weakening)
---------------------------------------------------------------------------
-- A concept holds POSSIBLY in a context A when there is at least
-- one point of A at which it holds. In type theory this is the
-- DEPENDENT SUM Σ A B — a pair of a witness a : A and a proof of
-- B applied to that a.
--
-- Σ is left adjoint to weakening. The adjunction is:
--
--     (Σ A B → C) ≃ ((a : A) → B a → C)
--
-- A function from "there exists an a in A with B a, mapped to C" is
-- the same data as a function "for every a, B a implies C."

-- Reads as: "Mapping out of an existential is the same data as
-- universally consuming both the witness and its proof."

possibility-forward : {A C : Set} {B : A → Set}
                    → (Σ A B → C) → ((a : A) → B a → C)
possibility-forward f = λ a b → f (a , b)

-- Reads as: "Conversely, a function handling every (a, b) pair
-- assembles into a function out of the Σ-type."

possibility-backward : {A C : Set} {B : A → Set}
                     → ((a : A) → B a → C) → (Σ A B → C)
possibility-backward g = λ p → g (p .fst) (p .snd)

-- Adjunction proofs: forward and backward perfectly invert. Both
-- compositions reduce judgmentally to the identity, so the constant
-- cubical path `λ i → ...` is the witness.

possibility-fwd-bwd : {A C : Set} {B : A → Set} (g : (a : A) → B a → C)
                    → possibility-forward (possibility-backward g) ≡ g
possibility-fwd-bwd g = λ i → g

possibility-bwd-fwd : {A C : Set} {B : A → Set} (f : Σ A B → C)
                    → possibility-backward (possibility-forward f) ≡ f
possibility-bwd-fwd f = λ i → f

---------------------------------------------------------------------------
-- SECTION 3: NECESSITY (Π, Right Adjoint to Weakening)
---------------------------------------------------------------------------
-- A concept holds NECESSARILY in a context A when it holds at EVERY
-- point of A. In type theory this is the DEPENDENT PRODUCT
-- (a : A) → B a, sometimes written Π A B.
--
-- Π is right adjoint to weakening. The adjunction is:
--
--     ((a : A) → C → B a) ≃ (C → (a : A) → B a)
--
-- A family of functions C → B a (one per a) is the same data as a
-- single function from C to the dependent product.

-- Reads as: "Giving a function C → B a for each a is the same as
-- giving a single function C → ∀a. B a."

necessity-forward : {A C : Set} {B : A → Set}
                  → ((a : A) → C → B a) → (C → ((a : A) → B a))
necessity-forward f = λ c a → f a c

necessity-backward : {A C : Set} {B : A → Set}
                   → (C → ((a : A) → B a)) → ((a : A) → C → B a)
necessity-backward g = λ a c → g c a

-- Adjunction proofs.

necessity-fwd-bwd : {A C : Set} {B : A → Set} (g : C → ((a : A) → B a))
                  → necessity-forward (necessity-backward g) ≡ g
necessity-fwd-bwd g = λ i → g

necessity-bwd-fwd : {A C : Set} {B : A → Set} (f : (a : A) → C → B a)
                  → necessity-backward (necessity-forward f) ≡ f
necessity-bwd-fwd f = λ i → f

---------------------------------------------------------------------------
-- SECTION 4: NECESSITY PRESERVES ESSENCE
---------------------------------------------------------------------------
-- We connect this chapter to Chapter 5. Recall: a proposition is a
-- type where any two inhabitants are identified.
--
-- Claim: "If B a is a proposition for every a : A, then the
-- dependent product (a : A) → B a is also a proposition."
--
-- That is, Necessity PRESERVES Essence. The universal quantification
-- of a family of essential types is itself essential.

-- Reads as: "If B a is essentially-without-distinction for every a,
-- then any two universal proofs (a : A) → B a are themselves
-- essentially identified — pointwise, at each a."

Π-preserves-prop : {A : Set} {B : A → Set}
                 → ((a : A) → isProp (B a))
                 → isProp ((a : A) → B a)
Π-preserves-prop B-prop f g = λ i a → B-prop a (f a) (g a) i

-- This is a small but genuine theorem linking the Logic of Essence
-- (Chapter 5) to the Logic of Actuality (Chapter 6). Necessity does
-- not destroy essence; it preserves it.

------------------------------------------------------------------------
-- WHAT WE BUILT
--
-- Across six chapters:
--   - The basics: Concepts as types, Judgments as typing, Syllogism
--     as composition.
--   - The Logic of Being: Pure Being (⊤) and Pure Nothing (⊥) and
--     the bare arrows between them.
--   - Cubical Determinate Being: contractibility of ⊤, the
--     curry/uncurry adjunction, and the negation modality.
--   - Unity and Aufhebung: a Higher Inductive Type identifying Sein
--     and Nichts; Moments and Co-Moments as records with coherence
--     laws; Unity of Opposites as adjunction; the initial opposition
--     ∅ ⊣ * built and verified.
--   - The Logic of Essence: Propositions (isProp), Ω as classifier
--     of essences, Reflection as characteristic map X → Ω, with a
--     non-trivial example on Booleans.
--   - Actuality: the adjoint triple Σ ⊣ W ⊣ Π, identified with the
--     Lawvere reading of Possibility ⊣ Actuality ⊣ Necessity, plus
--     a theorem that Necessity preserves Essence.
--
-- WHAT WE DID NOT BUILD (BUT COULD)
--
--   - A non-trivial AUFHEBUNG instance (the record from Chapter 4
--     is defined but uninhabited so far).
--   - The Doctrine of Quality vs. Quantity (the Lawvere program's
--     differential cohesion).
--   - The Doctrine of the Notion proper — universality,
--     particularity, individuality as a unity.
--   - Actual use of the `werden` path — e.g., transporting a
--     function defined on `being` to one defined on `nothing` and
--     observing the result.
--
-- These are projects for further chapters.
------------------------------------------------------------------------
