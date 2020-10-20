module Test.Main where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number (nan, isNaN, infinity, isFinite, fromString)
import Data.Number.Format (precision, fixed, exponential, toStringWith,
                           toString)
import Data.Number.Approximate (Fraction(..), Tolerance(..), eqRelative,
                                eqAbsolute, (≅), (≇))

import Effect (Effect)

import Test.Assert (assertTrue', assertFalse', assertEqual)


-- | Comparison up to 10% relative error.
eqRelative' ∷ Number → Number → Boolean
eqRelative' = eqRelative (Fraction 0.1)

infix 1 eqRelative' as ~=

-- | Comparison up to 0.1 absolute error.
eqAbsolute' ∷ Number → Number → Boolean
eqAbsolute' = eqAbsolute (Tolerance 0.1)

infix 1 eqAbsolute' as =~=

main :: Effect Unit
main = do


  -- suite "Data.Number.fromString" do
    -- test "valid number string" do
  assertTrue' "integer strings are coerced" $
    fromMaybe false $ map (_ == 123.0) $ fromString "123"

  assertTrue' "decimals are coerced" $
    fromMaybe false $ map (_ == 12.34) $ fromString "12.34"

  assertTrue' "exponents are coerced" $
    fromMaybe false $ map (_ == 1e4) $ fromString "1e4"

  assertTrue' "decimals exponents are coerced" $
    fromMaybe false $ map (_ == 1.2e4) $ fromString "1.2e4"

    -- test "invalid number string" do
  assertTrue' "invalid strings are not coerced" $
    Nothing == fromString "bad string"

    -- test "too large numbers" do
  assertTrue' "too large numbers are not coerced" $
    Nothing == fromString "1e1000"

  -- suite "Data.Number.isNaN" do
    -- test "Check for NaN" do
  assertTrue' "NaN is not a number" $ isNaN nan
  assertFalse' "infinity is a number" $ isNaN infinity
  assertFalse' "1.0 is a number" $ isNaN 1.0

  -- suite "Data.Number.isFinite" do
    -- test "Check for infinity" do
  assertTrue' "1.0e100 is a finite number" $ isFinite 1.0e100
  assertFalse' "detect positive infinity" $ isFinite infinity
  assertFalse' "detect negative infinity" $ isFinite (-infinity)
  assertFalse' "detect NaN" $ isFinite nan

  let pi = 3.14159
  -- suite "Data.Format.toStringWith" do

    -- test "precision" do
  assertEqual
    { expected: "3.14"
    , actual: toStringWith (precision 3) pi
    }
  assertEqual
    { expected: "3.1416"
    , actual: toStringWith (precision 5) pi
    }
  assertEqual
    { expected: "3"
    , actual: toStringWith (precision 1) pi
    }
  assertEqual
    { expected: "3"
    , actual: toStringWith (precision (-3)) pi
    }
  assertEqual
    { expected: "3.14"
    , actual: toStringWith (precision 3) pi
    }
  assertEqual
    { expected: "1.2e+3"
    , actual: toStringWith (precision 2) 1234.5
    }

    -- test "fixed" do
  assertEqual
    { expected: "3.14"
    , actual: toStringWith (fixed 2) pi
    }
  assertEqual
    { expected: "3.1416"
    , actual: toStringWith (fixed 4) pi
    }
  assertEqual
    { expected: "3"
    , actual: toStringWith (precision 0) pi
    }
  assertEqual
    { expected: "3"
    , actual: toStringWith (precision (-3)) pi
    }
  assertEqual
    { expected: "1234.5"
    , actual: toStringWith (fixed 1) 1234.5
    }

    -- test "exponential" do
  assertEqual
    { expected: "3e+0"
    , actual: toStringWith (exponential 0) pi
    }
  assertEqual
    { expected: "3.14e+0"
    , actual: toStringWith (exponential 2) pi
    }
  assertEqual
    { expected: "3.14e+2"
    , actual: toStringWith (exponential 2) (100.0 * pi)
    }
  assertEqual
    { expected: "1.2e+3"
    , actual: toStringWith (exponential 1) 1234.5
    }

  -- suite "Data.Format.toString" do

    -- test "toString" do
  assertEqual
    { expected: "3.14159"
    , actual: toString pi
    }

  assertEqual
    { expected: "10"
    , actual: toString 10.0
    }

  -- suite "Data.Number.Approximate.eqRelative" do
    -- test "eqRelative" do
  assertTrue' "should return true for differences smaller 10%" $
    10.0 ~= 10.9

  assertTrue' "should return true for differences smaller 10%" $
    10.0 ~= 9.2

  assertFalse' "should return false for differences larger than 10%" $
    10.0 ~= 11.1

  assertFalse' "should return false for differences larger than 10%" $
    10.0 ~= 9.01

    -- test "eqRelative (large numbers)" do
  assertTrue' "should return true for differences smaller 10%" $
    100000000000.0 ~= 109000000000.0

  assertTrue' "should return true for differences smaller 10%" $
    100000000000.0 ~= 92000000000.0

  assertFalse' "should return false for differences larger than 10%" $
    100000000000.0 ~= 111000000000.0

  assertFalse' "should return false for differences larger than 10%" $
    100000000000.0 ~= 90000000000.0

    -- test "eqRelative (small numbers)" do
  assertTrue' "should return true for differences smaller 10%" $
    0.000000000001 ~= 0.00000000000109

  assertTrue' "should return true for differences smaller 10%" $
    0.000000000001 ~= 0.00000000000092

  assertFalse' "should return false for differences larger than 10%" $
    0.000000000001 ~= 0.00000000000111

      -- assertFalse
  assertFalse' "should return false for differences larger than 10%" $
    0.000000000001 ~= 0.0000000000009

    -- test "eqRelative (negative numbers)" do
  assertTrue' "should return true for differences smaller 10%" $
    -10.0 ~= -10.9

  assertTrue' "should return true for differences smaller 10%" $
    -10.0 ~= -9.2

  assertFalse' "should return false for differences larger than 10%" $
    -10.0 ~= -11.1

  assertFalse' "should return false for differences larger than 10%" $
    -10.0 ~= -9.01

    -- test "eqRelative (close or equal to 0.0)" do
  assertTrue' "should compare against the fraction if left argument is zero" $
    0.0 ~= 0.0001

  assertTrue' "should compare against the fraction if right argument is zero" $
    0.0001 ~= 0.0

  assertTrue' "should succeed if both arguments are zero" $
    0.0 ~= 0.0

  assertFalse' "should fail if argument is larger than fraction" $
    0.0 ~= 0.11

  assertFalse' "should fail if other argument is not exactly zero" $
    1.0e-100 ~= 0.1

    -- test "eqRelative (fraction = 0.0)" do
  assertTrue' "should succeed if numbers are exactly equal" $
    eqRelative (Fraction 0.0) 3.14 3.14

  assertFalse' "should fail if numbers are not exactly equal" $
    eqRelative (Fraction 0.0) 3.14 3.14000000000001

    -- test "eqRelative (fraction > 1.0)" do
  assertTrue' "should work for 'fractions' larger than one" $
    eqRelative (Fraction 3.0) 10.0 29.5


  -- suite "Data.Number.Approximate.eqApproximate" do
  --   test "0.1 + 0.2 ≅ 0.3" do
  assertTrue' "0.1 + 0.2 should be approximately equal to 0.3" $
    0.1 + 0.2 ≅ 0.3

  assertTrue' "0.1 + 0.200001 should not be approximately equal to 0.3" $
    0.1 + 0.200001 ≇ 0.3


  -- suite "Data.Number.Approximate.eqAbsolute" do
  --   test "eqAbsolute" do
  assertTrue' "should succeed for differences smaller than the tolerance" $
    10.0 =~= 10.09

  assertTrue' "should succeed for differences smaller than the tolerance" $
    9.91 ~= 10.00

  assertFalse' "should fail for differences larger than the tolerance" $
    10.0 =~= 10.11

  assertFalse' "should fail for differences larger than the tolerance" $
    9.89 =~= 10.0

    -- test "eqAbsolute (compare against 0)" do
  assertTrue' "should succeed for numbers smaller than the tolerance" $
    0.0 ~= -0.09
