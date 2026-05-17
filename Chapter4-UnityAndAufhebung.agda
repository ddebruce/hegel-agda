{-# OPTIONS --cubical --guardedness #-}

------------------------------------------------------------------------
-- CHAPTER 4: UNITY AND AUFHEBUNG
--
-- WHERE WE WERE
-- Chapter 3 gave us real cubical content: contractibility of ⊤, the
-- curry/uncurry adjunction, the double-negation unit X → ¬¬X. The
-- double-negation unit was our first hint of a "modal operator"
-- pattern.
--
-- WHAT THIS CHAPTER DOES
-- This is the most distinctively Hegelian chapter. We do five things:
--
--   1. Sein ≡ Nichts — Hegel's famous claim that Pure Being and
--      Pure Nothing are identical in their truth — captured by a
--      HIGHER INDUCTIVE TYPE with a path constructor between them.
--      This is where the `--cubical` pragma truly earns its keep.
--
--   2. MOMENTS (monads) and CO-MOMENTS (comonads) as records with
--      explicit coherence laws — capturing the structural sense in
--      which a concept can have a "moment" or quality projected
--      from it.
--
--   3. UNITY OF OPPOSITES as an adjunction between a Moment and a
--      Co-Moment, with full inverse proofs (no "garbage" inhabitants
--      can pose as a Unity).
--
--   4. The INITIAL OPPOSITION ∅ ⊣ * — the formal residue of the
--      Being/Nothing duality, constructed as a verified instance
--      of UnityOfOpposites with every law provided.
--
--   5. AUFHEBUNG as a record capturing the structural form of a
--      higher Unity subsuming a lower one. We do not yet construct
--      a non-trivial instance — that awaits richer modalities in
--      later chapters.
--
-- WHAT IS COMING NEXT
-- Chapter 5 turns to the DOCTRINE OF ESSENCE (the second book of
-- Hegel's Logic), introducing the type universe of propositions Ω
-- and characteristic maps as Reflection.
------------------------------------------------------------------------

module Chapter4-UnityAndAufhebung where

open import Cubical.Core.Primitives
open import Cubical.Foundations.Prelude using (refl)
open import Chapter2-LogicOfBeing
open import Chapter3-DeterminateBeing

---------------------------------------------------------------------------
-- SECTION 1: SEIN ≡ NICHTS (Becoming as a Higher Inductive Type)
---------------------------------------------------------------------------
-- Hegel's most famous early claim is that "Being and Nothing are the
-- same" — not approximately, but equal in their truth. In a CONSISTENT
-- logic we cannot literally make ⊤ judgmentally equal to ⊥ without
-- breaking everything (we would have a term of every type, since ⊤
-- is inhabited).
--
-- Cubical Agda offers a softer option: introduce a new type that
-- contains both Being and Nothing AND a path identifying them. This
-- is called a HIGHER INDUCTIVE TYPE (HIT). It has:
--   - point constructors (`being`, `nothing`)
--   - a PATH constructor (`werden` — German "becoming") that adds a
--     built-in identification between two points
--
-- The identification is structural (path-level), not judgmental, so
-- consistency is preserved. This is the closest a consistent formal
-- system comes to "Sein = Nichts": it captures the FORM of Hegel's
-- claim while respecting the meta-constraints of formal logic.

-- Reads as: "Becoming is a space containing the point `being`, the
-- point `nothing`, and a path `werden` between them — identifying
-- them not by equation but by an explicit continuous transition."

data Becoming : Set where
  being   : Becoming
  nothing : Becoming
  werden  : being ≡ nothing

---------------------------------------------------------------------------
-- SECTION 2: MOMENTS AND CO-MOMENTS (Monads and Comonads with laws)
---------------------------------------------------------------------------
-- Hegel uses the word "Moment" not in the temporal sense but as a
-- structural component of a concept — a quality that can be PROJECTED
-- OUT of a concept.
--
-- Mathematically, this projection is a MONAD: a functor ◯ together
-- with a unit η (inserting into ◯) and a multiplication μ (collapsing
-- nested applications). To rule out garbage inhabitants of the
-- record, we demand the standard coherence laws:
--
--   - functoriality (`map` and `map-id`)        — ◯ acts on functions
--   - left-unit law      μ(η x)     = x          — η on the inside
--   - right-unit law     μ(map η x) = x          — η on the outside
--
-- A CO-MOMENT is the dual: a comonad with counit ε (extracting from
-- ◻) and comultiplication δ (duplicating).
--
-- Any inhabitant of these records is therefore a real (co)monad — not
-- just a tuple of functions with the right shape.

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

-- A fully-axiomatised monad also requires associativity
--   μ (map μ x) ≡ μ (μ x)
-- and functoriality of composition. We omit these to keep the
-- record manageable; the two instances we construct below satisfy
-- all monad laws trivially.

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

---------------------------------------------------------------------------
-- SECTION 3: THE UNITY OF OPPOSITES (Adjoint Moments)
---------------------------------------------------------------------------
-- Hegel's "unity of opposites" binds a Moment and a Co-Moment together.
-- The categorical name for this binding is an ADJUNCTION C ⊣ M
-- between functors.
--
-- An adjunction is a natural isomorphism
--
--     Hom(◻ X, Y) ≃ Hom(X, ◯ Y)
--
-- meaning a function from ◻X to Y is "the same data" as a function
-- from X to ◯Y, with a bijection that perfectly inverts.
--
-- We capture this with `forward`, `backward`, and the two inverse
-- proofs `fwd-bwd` and `bwd-fwd`. The inverse proofs are what
-- prevent garbage inhabitants of the record.

-- Reads as: "A Unity of Opposites is a pair of mutually inverse
-- translations: one direction sends maps out of ◻X-into-Y to maps
-- of X-into-◯Y, and the other sends them back, with proofs that
-- each round trip returns the original."

record UnityOfOpposites (C : CoMoment) (M : Moment) : Set₁ where
  field
    forward  : {X Y : Set} → (CoMoment.◻ C X → Y) → (X → Moment.◯ M Y)
    backward : {X Y : Set} → (X → Moment.◯ M Y) → (CoMoment.◻ C X → Y)
    fwd-bwd  : {X Y : Set} (f : X → Moment.◯ M Y) (x : X)
             → forward (backward f) x ≡ f x
    bwd-fwd  : {X Y : Set} (g : CoMoment.◻ C X → Y) (cx : CoMoment.◻ C X)
             → backward (forward g) cx ≡ g cx

-- A full notion would also demand naturality of `forward` and
-- `backward` in both variables. We omit that here for brevity; the
-- instance below is natural by inspection.

---------------------------------------------------------------------------
-- SECTION 4: THE INITIAL OPPOSITION (∅ ⊣ *)
---------------------------------------------------------------------------
-- We now construct our first INSTANCE of UnityOfOpposites — the
-- starting point of Hegel's whole development.
--
-- According to the Lawvere/nLab reading of the Science of Logic, the
-- "initial opposition" is between the constant functor at the empty
-- type (the left adjoint, representing Nothing) and the constant
-- functor at the unit type (the right adjoint, representing Being).
--
-- This adjunction is trivial in content — both Hom-sets are
-- contractible — but that triviality is faithful to the Lawvere
-- reading: it is the BARE MINIMUM categorical structure on which
-- all further determinations of being and essence are built.

-- The constant comonad at ⊥: ◻ X = ⊥ for every X.
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

-- The constant monad at ⊤: ◯ X = ⊤ for every X. All laws are
-- discharged by `refl`, because ⊤ has eta and so any two of its
-- inhabitants are judgmentally equal to `tt`.
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

-- The initial opposition: every required field is a real term, and
-- Agda verifies the inverse proofs. The vacuous cases on the
-- Nothing side use the absurd pattern; the ⊤ side uses `refl`
-- because ⊤'s eta-equality makes any path between inhabitants
-- definitionally `refl`.
Becoming-Adjunction : UnityOfOpposites Nothing-CoMoment Being-Moment
Becoming-Adjunction = record
  { forward  = λ f x → tt
  ; backward = λ g ()
  ; fwd-bwd  = λ f x → refl
  ; bwd-fwd  = λ g ()
  }

---------------------------------------------------------------------------
-- SECTION 5: AUFHEBUNG (Sublation as one Unity containing another)
---------------------------------------------------------------------------
-- Hegel's word "Aufhebung" combines three meanings: to cancel, to
-- preserve, to elevate. A sublation cancels the contradiction of a
-- lower Unity, preserves its moments, and raises them to a resolved
-- higher Unity.
--
-- We model this as: a HIGHER UnityOfOpposites that subsumes a lower
-- one via an inclusion of the lower moment into the higher.
--
-- This record captures the "contains" aspect but understates Hegel's
-- structure (a real account would require the inclusion to commute
-- with the moment operations and would track HOW the contradiction
-- is resolved at the higher level). We do not yet construct an
-- Aufhebung instance; that awaits richer modalities introduced in
-- later chapters.

-- Reads as: "An Aufhebung of a lower (C₁ ⊣ M₁) is a higher Unity
-- (sublating-C ⊣ sublating-M) plus a function showing the lower
-- moment is contained in the higher moment."

record Aufhebung (C₁ : CoMoment) (M₁ : Moment) : Set₁ where
  field
    sublating-C : CoMoment
    sublating-M : Moment
    sublating-Unity : UnityOfOpposites sublating-C sublating-M
    preserve-elevate : {X : Set} → Moment.◯ M₁ X → Moment.◯ sublating-M X

------------------------------------------------------------------------
-- WHAT'S NEXT
--
-- Chapter 5 turns to the DOCTRINE OF ESSENCE — Hegel's second book.
-- We move from the bare opposition of ⊥ and ⊤ to the structured
-- universe of mere propositions (Ω), and to the notion of
-- "Reflection" — a concept mirrored within the universe of essential
-- truths.
------------------------------------------------------------------------
