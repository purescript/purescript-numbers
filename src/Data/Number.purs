-- | Functions for working with PureScripts builtin `Number` type.
module Data.Number
  ( fromString
  , nan
  , isNaN
  , infinity
  , isFinite
  , abs
  , acos
  , asin
  , atan
  , atan2
  , ceil
  , cos
  , exp
  , floor
  , log
  , max
  , min
  , pow
  , remainder, (%)
  , round
  , sign
  , sin
  , sqrt
  , tan
  , trunc
  , e
  , ln2
  , ln10
  , log10e
  , log2e
  , pi
  , sqrt1_2
  , sqrt2
  , tau
  ) where

import Data.Function.Uncurried (Fn4, runFn4)
import Data.Maybe (Maybe(..))
import Data.Ord ((<))

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

-- | Returns the absolute value of the argument.
foreign import abs :: Number -> Number

-- | Returns the inverse cosine in radians of the argument.
foreign import acos :: Number -> Number

-- | Returns the inverse sine in radians of the argument.
foreign import asin :: Number -> Number

-- | Returns the inverse tangent in radians of the argument.
foreign import atan :: Number -> Number

-- | Four-quadrant tangent inverse. Given the arguments `y` and `x`, returns
-- | the inverse tangent of `y / x`, where the signs of both arguments are used
-- | to determine the sign of the result.
-- | If the first argument is negative, the result will be negative.
-- | The result is the angle between the positive x axis and  a point `(x, y)`.
foreign import atan2 :: Number -> Number -> Number

-- | Returns the smallest integer not smaller than the argument.
foreign import ceil :: Number -> Number

-- | Returns the cosine of the argument, where the argument is in radians.
foreign import cos :: Number -> Number

-- | Returns `e` exponentiated to the power of the argument.
foreign import exp :: Number -> Number

-- | Returns the largest integer not larger than the argument.
foreign import floor :: Number -> Number

-- | Returns the natural logarithm of a number.
foreign import log :: Number -> Number

-- | Returns the largest of two numbers. Unlike `max` in Data.Ord this version
-- | returns NaN if either argument is NaN.
foreign import max :: Number -> Number -> Number

-- | Returns the smallest of two numbers. Unlike `min` in Data.Ord this version
-- | returns NaN if either argument is NaN.
foreign import min :: Number -> Number -> Number

-- | Return  the first argument exponentiated to the power of the second argument.
foreign import pow :: Number -> Number -> Number

-- | Computes the remainder after division, wrapping Javascript's `%` operator.
foreign import remainder :: Number -> Number -> Number

infixl 7 remainder as %

-- | Returns the integer closest to the argument.
foreign import round :: Number -> Number

-- | Returns either a positive or negative +/- 1, indicating the sign of the
-- | argument. If the argument is 0, it will return a +/- 0. If the argument is
-- | NaN it will return NaN.
foreign import sign :: Number -> Number

-- | Returns the sine of the argument, where the argument is in radians.
foreign import sin :: Number -> Number

-- | Returns the square root of the argument.
foreign import sqrt :: Number -> Number

-- | Returns the tangent of the argument, where the argument is in radians.
foreign import tan :: Number -> Number

-- | Truncates the decimal portion of a number. Equivalent to `floor` if the
-- | number is positive, and `ceil` if the number is negative.
trunc :: Number -> Number
trunc x = if x < 0.0 then ceil x else floor x

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
