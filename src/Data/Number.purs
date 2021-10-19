-- | Functions for working with PureScripts builtin `Number` type.
module Data.Number
  ( fromString
  , epsilon
  , nan
  , isNaN
  , infinity
  , negativeInfinity
  , isFinite
  , minValue
  , maxValue
  ) where

import Data.Function.Uncurried (Fn4, runFn4)
import Data.Maybe (Maybe(..))

-- | The `Number` value for the magnitude of the difference between 1 and
-- | the smallest value greater than 1 that is representable as a 
-- | `Number` value, which is approximately 
-- | 2.2204460492503130808472633361816 × 10⁻¹⁶
foreign import epsilon :: Number

-- | Not a number (NaN)
foreign import nan :: Number

-- | Test whether a number is NaN
foreign import isNaN :: Number -> Boolean

-- | Positive infinity, +∞𝔽
foreign import infinity :: Number

-- | Negative inifinity, -∞𝔽
foreign import negativeInfinity :: Number

-- | Test whether a number is finite
foreign import isFinite :: Number -> Boolean

-- | Attempt to parse a `Number` using JavaScripts `parseFloat`. Returns
-- | `Nothing` if the parse fails or if the result is not a finite number.
-- |
-- | Example:
-- | ```purs
-- | > fromString "123"
-- | (Just 123.0)
-- |
-- | > fromString "12.34"
-- | (Just 12.34)
-- |
-- | > fromString "1e4"
-- | (Just 10000.0)
-- |
-- | > fromString "1.2e4"
-- | (Just 12000.0)
-- |
-- | > fromString "bad"
-- | Nothing
-- | ```
-- |
-- | Note that `parseFloat` allows for trailing non-digit characters and
-- | whitespace as a prefix:
-- | ```
-- | > fromString "  1.2 ??"
-- | (Just 1.2)
-- | ```
fromString :: String -> Maybe Number
fromString str = runFn4 fromStringImpl str isFinite Just Nothing

foreign import fromStringImpl :: Fn4 String (Number -> Boolean) (forall a. a -> Maybe a) (forall a. Maybe a) (Maybe Number)

-- | The largest positive finite value of the `Number` type, which is 
-- | approximately 1.7976931348623157 × 10³⁰⁸
foreign import maxValue :: Number

-- | The smallest positive value of the `Number` type, which is 
-- | approximately 5 × 10⁻³²⁴
foreign import minValue :: Number
