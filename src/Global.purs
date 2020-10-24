-- | This module defines types for some global Javascript functions
-- | and values.
module Global
  ( nan
  , isNaN
  , infinity
  , isFinite
  , readInt
  , readFloat
  , toFixed
  , toExponential
  , toPrecision
  ) where

import Prelude
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

-- | Parse an integer from a `String` in the specified base
foreign import readInt :: Int -> String -> Number

-- | Parse a floating point value from a `String`
foreign import readFloat :: String -> Number

foreign import _toFixed :: forall a. Fn4 (String -> a) (String -> a) Int Number a

foreign import _toExponential :: forall a. Fn4 (String -> a) (String -> a) Int Number a

foreign import _toPrecision :: forall a. Fn4 (String -> a) (String -> a) Int Number a

-- | Formats Number as a String with limited number of digits after the dot.
-- | May return `Nothing` when specified number of digits is less than 0 or
-- | greater than 20. See ECMA-262 for more information.
toFixed :: Int -> Number -> Maybe String
toFixed digits n = runFn4 _toFixed (const Nothing) Just digits n

-- | Formats Number as String in exponential notation limiting number of digits
-- | after the decimal dot. May return `Nothing` when specified number of
-- | digits is less than 0 or greater than 20 depending on the implementation.
-- | See ECMA-262 for more information.
toExponential :: Int -> Number -> Maybe String
toExponential digits n = runFn4 _toExponential (const Nothing) Just digits n

-- | Formats Number as String in fixed-point or exponential notation rounded
-- | to specified number of significant digits. May return `Nothing` when
-- | precision is less than 1 or greater than 21 depending on the
-- | implementation. See ECMA-262 for more information.
toPrecision :: Int -> Number -> Maybe String
toPrecision digits n = runFn4 _toPrecision (const Nothing) Just digits n
