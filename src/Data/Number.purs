-- | A module for working with PureScripts builtin `Number` type.
module Data.Number
  ( Fraction
  , eqRelative
  , Precision
  , eqAbsolute
  ) where

import Prelude

import Math (abs)

-- | A type alias for (small) numbers, typically in the range *[0:1]*.
type Fraction = Number

-- | Compare two `Number`s and return `true` if they are equal up to the
-- | given *relative* error (`Fraction` parameter).
-- |
-- | This comparison is scale-invariant, i.e. if `eqRelative frac x y`, then
-- | `eqRelative frac (s * x) (s * y)` for a given scale factor `s > 0.0`
-- | (unless one of x, y is exactly `0.0`).
-- |
-- | Example:
-- | ``` purs
-- | > (eqRelative 0.01) 133.7 133.0
-- | true
-- |
-- | > (eqRelative 0.001) 133.7 133.0
-- | false
-- | ```
eqRelative ∷ Fraction → Number → Number → Boolean
eqRelative fraction 0.0   y =       abs y <= fraction
eqRelative fraction   x 0.0 =       abs x <= fraction
eqRelative fraction   x   y = abs (x - y) <= fraction * abs (x + y) / 2.0

-- | A(nother) type alias for (small) numbers.
type Precision = Number

-- | Compare two `Number`s and return `true` if they are equal up to the given
-- | (absolute) precision. Note that this comparison is *not* scale-invariant.
-- |
-- | Example:
-- | ``` purs
-- | > (eqAbsolute 1.0) 133.7 133.0
-- | true
-- |
-- | > (eqAbsolute 0.1) 133.7 133.0
-- | false
-- | ```
eqAbsolute ∷ Precision → Number → Number → Boolean
eqAbsolute precision x y = abs (x - y) <= precision
