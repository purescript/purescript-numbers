-- | Functions for working with PureScripts builtin `Number` type.
module Data.Number
  ( fromString
  , nan
  , isNaN
  , infinity
  , isFinite
  ) where

import Data.Function.Uncurried (Fn4, runFn4)
import Data.Maybe (Maybe(..))

-- | Not a number (NaN)
foreign import nan :: Number

-- | Test whether a number is NaN
foreign import isNaN :: Number -> Boolean

-- | Positive infinity
foreign import infinity :: Number

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

-- | The base of natural logarithms, *e*, around 2.71828.
e :: Number
e = 2.718281828459045

-- | The natural logarithm of 2, around 0.6931.
ln2 :: Number
ln2 = 0.6931471805599453

-- | The natural logarithm of 10, around 2.3025.
ln10 :: Number
ln10 = 2.302585092994046

-- | Base 10 logarithm of `e`, around 0.43429.
log10e :: Number
log10e = 0.4342944819032518

-- | The base 2 logarithm of `e`, around 1.4426.
log2e :: Number
log2e = 1.4426950408889634

-- | The ratio of the circumference of a circle to its diameter, around 3.14159.
pi :: Number
pi = 3.141592653589793

-- | The Square root of one half, around 0.707107.
sqrt1_2 :: Number
sqrt1_2 = 0.7071067811865476

-- | The square root of two, around 1.41421.
sqrt2 :: Number
sqrt2 = 1.4142135623730951

-- | The ratio of the circumference of a circle to its radius, around 6.283185.
tau :: Number
tau = 6.283185307179586
