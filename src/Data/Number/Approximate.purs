-- | A module for `Number`s that use a comparison function with an allowed
-- | relative error of *1ppm*.
-- |
-- | Example:
-- | ``` purs
-- | > 0.1 + 0.2 == 0.3
-- | false
-- |
-- | > Approximate 0.1 + Approximate 0.2 == Approximate 0.3
-- | true
-- | ```
module Data.Number.Approximate
  ( Approximate(..)
  ) where

import Prelude

import Data.Number as N

-- | A newtype for `Number`s that use `eqRelative` with a maximum relative
-- | error of *1ppm* for comparison.
newtype Approximate = Approximate Number

instance eqApproximate ∷ Eq Approximate where
  eq (Approximate x) (Approximate y) = N.eqRelative onePPM x y
    where onePPM = 1.0e-6

instance ordApproximate ∷ Ord Approximate where
  compare rx@(Approximate x) ry@(Approximate y) | rx == ry =  EQ
                                                | x > y =     GT
                                                | otherwise = LT

instance showApproximate ∷ Show Approximate where
  show (Approximate x) | x >= 0.0  = "Approximate " <> show x
                       | otherwise = "Approximate (" <> show x <> ")"

lift ∷ (Number → Number → Number) → (Approximate → Approximate → Approximate)
lift fn (Approximate x) (Approximate y) = Approximate (fn x y)

instance semiringApproximate ∷ Semiring Approximate where
  add = lift (+)
  zero = Approximate 0.0
  mul = lift (*)
  one = Approximate 1.0

instance ringApproximate ∷ Ring Approximate where
  sub = lift (-)

instance commutativeRingApproximate ∷ CommutativeRing Approximate

instance euclideanRingApproximate ∷ EuclideanRing Approximate where
  degree _ = 1
  div = lift (/)
  mod _ _ = zero

instance fieldApproximate :: Field Approximate
