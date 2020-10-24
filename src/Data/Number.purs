-- | Functions for working with PureScripts builtin `Number` type.
module Data.Number
  ( fromString
  , nan
  , isNaN
  , infinity
  , isFinite
  , readInt
  , readFloat
  , fromString
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
fromString = readFloat >>> check
  where
    check num | isFinite num = Just num
              | otherwise    = Nothing

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
