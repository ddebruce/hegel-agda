{-# OPTIONS --cubical --guardedness #-}

------------------------------------------------------------------------
-- CHAPTER 5: THE LOGIC OF ESSENCE
--
-- WHERE WE WERE
-- Chapters 1-4 covered the Doctrine of Being: Concepts, Pure Being,
-- Pure Nothing, their identification via a Higher Inductive Type,
-- the framework of Moments and the initial opposition ∅ ⊣ *.
--
-- WHAT THIS CHAPTER DOES
-- We move from Hegel's first book (Doctrine of Being) to his second
-- (Doctrine of Essence). The major shift: from "what is there?" to
-- "what is essential?" — meaning, what survives once mere appearance
-- (Schein) is set aside.
--
-- We capture this with two type-theoretic notions:
--
--   1. PROPOSITIONS (isProp) — types where any two inhabitants are
--      identified by a path. These are the "essential" types in HoTT:
--      they carry no information beyond their truth value.
--
--   2. Ω (omega) — the type of all propositions, called the SUBOBJECT
--      CLASSIFIER. A higher-order "register" of all essential types.
--
-- We also introduce REFLECTION as a characteristic function X → Ω,
-- assigning each x : X a proposition (its essential truth).
--
-- HONEST CAVEAT
-- Ω is NOT the full type universe `Type` (which is itself reflective
-- via univalence). Ω is the sub-universe of MERE PROPOSITIONS. The
-- Lawvere/nLab reading of Hegel's "essence as reflection within
-- itself" often points at the full type universe; here we capture
-- the proposition-level fragment, which is mathematically cleaner.
--
-- WHAT IS COMING NEXT
-- Chapter 6 introduces ACTUALITY (Wirklichkeit) and the adjoint
-- triple of Possibility, Actuality, and Necessity — the categorial
-- structure of dependent types — and links back to this chapter
-- by showing that Necessity preserves Essence.
------------------------------------------------------------------------

module Chapter5-LogicOfEssence where

open import Cubical.Core.Primitives
open import Chapter2-LogicOfBeing

---------------------------------------------------------------------------
-- SECTION 1: PROPOSITIONS (Essential Truths)
---------------------------------------------------------------------------
-- A type A is a PROPOSITION (isProp A) when any two inhabitants of
-- A are path-equal. This means A has at most one "way to be true":
-- it carries no information beyond its truth value.
--
-- Examples:
--   - ⊤ is a proposition (only one inhabitant, trivially identified)
--   - ⊥ is a proposition (no inhabitants, vacuously identified)
--   - Bool is NOT a proposition (`true` and `false` are not connected
--     by a path)
--
-- Propositions are the "essential" types in HoTT: they discard all
-- internal variation. This matches Hegel's contrast between the
-- surface appearance (Schein) of a concept and its essence (Wesen).

-- Reads as: "A type A is a proposition when any two of its elements
-- x and y are connected by a path — i.e., essentially the same."

isProp : Set → Set
isProp A = (x y : A) → x ≡ y

-- We prove Pure Being is a proposition. Given any two inhabitants of
-- ⊤, eta-equality makes both judgmentally equal to `tt`, so the
-- constant path λ i → tt connects them.

-- Reads as: "Pure Being is essentially without distinction: any two
-- of its points are identified."

⊤-is-prop : isProp ⊤
⊤-is-prop x y = λ i → tt

-- Pure Nothing is also a proposition — vacuously, because there are
-- no pairs of inhabitants to consider. The absurd pattern handles
-- the (impossible) input.

-- Reads as: "Pure Nothing is essentially without distinction
-- vacuously: there are no inhabitants whose distinction could arise."

⊥-is-prop : isProp ⊥
⊥-is-prop ()

---------------------------------------------------------------------------
-- SECTION 2: Ω, THE TYPE OF PROPOSITIONS
---------------------------------------------------------------------------
-- We collect all propositions into a single type Ω (also called
-- hProp, the type of "homotopy propositions"). An inhabitant of Ω
-- is a pair: a type, together with a proof it is a proposition.
--
-- Ω lives in `Set₁` because its inhabitants are pairs whose first
-- component is itself a `Set`. (A type whose values include types
-- must live one universe level up.)
--
-- This is also called the SUBOBJECT CLASSIFIER in topos theory:
-- every "subset" of a type X corresponds to a function X → Ω giving
-- its characteristic predicate.

-- Reads as: "Ω contains, for each `carrier` type, a proof that the
-- carrier is a proposition. Inhabiting Ω is being-essential."

record Ω : Set₁ where
  constructor prop
  field
    carrier : Set
    essence : isProp carrier

-- Specific propositions can now be placed into Ω. Each is an
-- "essence" — a type certified to be a mere proposition.

True-Essence : Ω
True-Essence = prop ⊤ ⊤-is-prop

False-Essence : Ω
False-Essence = prop ⊥ ⊥-is-prop

---------------------------------------------------------------------------
-- SECTION 3: REFLECTION (Characteristic Maps)
---------------------------------------------------------------------------
-- Hegel uses "Reflection" (Reflexion) for a concept's appearance
-- within the universe of essences. Mathematically, a Reflection is a
-- function X → Ω that assigns to each x in X its essential truth.
--
-- Equivalently, a Reflection is a SUBSET of X (the elements that
-- map to True-Essence) together with the characteristic information
-- for membership.

-- Reads as: "A Reflection on X is a rule assigning each x : X to an
-- essence (a proposition in Ω)."

Reflection : Set → Set₁
Reflection X = X → Ω

-- A TRIVIAL Reflection: send everything to True-Essence. Every
-- element is unconditionally essential. This doesn't exercise Ω's
-- classifying role at all.

all-true : {X : Set} → Reflection X
all-true x = True-Essence

-- A NON-TRIVIAL Reflection: on Booleans, send `true` to
-- True-Essence and `false` to False-Essence. This is a real
-- CHARACTERISTIC FUNCTION that distinguishes its inputs and uses Ω
-- as more than a placeholder.
--
-- (To define this we need a Boolean type. We declare one locally.)

data Bool : Set where
  true  : Bool
  false : Bool

-- Reads as: "Reflect a Boolean into Ω: true reflects to the
-- proposition `truth`, false reflects to the proposition `falsity`."

bool-reflect : Reflection Bool
bool-reflect true  = True-Essence
bool-reflect false = False-Essence

-- This shows how Ω plays its classifier role: a Reflection X → Ω
-- carves X into "true cases" and "false cases" (and more generally
-- into an entire space of propositions).

------------------------------------------------------------------------
-- WHAT'S NEXT
--
-- Chapter 6 introduces ACTUALITY (Wirklichkeit). We follow the
-- Lawvere/nLab reading: Hegel's modalities of Possibility, Actuality,
-- and Necessity correspond to the adjoint triple Σ ⊣ W ⊣ Π in
-- dependent type theory. We construct that triple, prove the
-- adjunctions, and link back to this chapter by showing that
-- dependent function types preserve propositionhood.
------------------------------------------------------------------------
