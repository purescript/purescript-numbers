module Test.Main where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number (nan, isNaN, infinity, isFinite, fromString)
import Data.Number.Format (precision, fixed, exponential, toStringWith,
                           toString)
import Data.Number.Approximate (Fraction(..), Tolerance(..), eqRelative,
                                eqAbsolute, (≅), (≇))

import Effect (Effect)

import Test.Unit (suite, test)
import Test.Unit.Assert (assert, assertFalse, equal)
import Test.Unit.Main (runTest)


-- | Comparison up to 10% relative error.
eqRelative' ∷ Number → Number → Boolean
eqRelative' = eqRelative (Fraction 0.1)

infix 1 eqRelative' as ~=

-- | Comparison up to 0.1 absolute error.
eqAbsolute' ∷ Number → Number → Boolean
eqAbsolute' = eqAbsolute (Tolerance 0.1)

infix 1 eqAbsolute' as =~=

main ∷ Effect Unit
main = runTest do


  suite "Data.Number.fromString" do
    test "valid number string" do
      assert "integer strings are coerced" $
        fromMaybe false $ map (_ == 123.0) $ fromString "123"

      assert "decimals are coerced" $
        fromMaybe false $ map (_ == 12.34) $ fromString "12.34"

      assert "exponents are coerced" $
        fromMaybe false $ map (_ == 1e4) $ fromString "1e4"

      assert "decimals exponents are coerced" $
        fromMaybe false $ map (_ == 1.2e4) $ fromString "1.2e4"

    test "invalid number string" do
      assert "invalid strings are not coerced" $
        Nothing == fromString "bad string"

    test "too large numbers" do
      assert "too large numbers are not coerced" $
        Nothing == fromString "1e1000"


  suite "Data.Number.isNaN" do
    test "Check for NaN" do
      assert "NaN is not a number" $ isNaN nan
      assertFalse "infinity is a number" $ isNaN infinity
      assertFalse "1.0 is a number" $ isNaN 1.0


  suite "Data.Number.isFinite" do
    test "Check for infinity" do
      assert "1.0e100 is a finite number" $ isFinite 1.0e100
      assertFalse "detect positive infinity" $ isFinite infinity
      assertFalse "detect negative infinity" $ isFinite (-infinity)
      assertFalse "detect NaN" $ isFinite nan


  let pi = 3.14159
  suite "Data.Format.toStringWith" do

    test "precision" do
      equal "3.14"    (toStringWith (precision 3) pi)
      equal "3.1416"  (toStringWith (precision 5) pi)
      equal "3"       (toStringWith (precision 1) pi)
      equal "3"       (toStringWith (precision (-3)) pi)
      equal "3.14"    (toStringWith (precision 3) pi)
      equal "1.2e+3"  (toStringWith (precision 2) 1234.5)

    test "fixed" do
      equal "3.14"    (toStringWith (fixed 2) pi)
      equal "3.1416"  (toStringWith (fixed 4) pi)
      equal "3"       (toStringWith (precision 0) pi)
      equal "3"       (toStringWith (precision (-3)) pi)
      equal "1234.5"  (toStringWith (fixed 1) 1234.5)

    test "exponential" do
      equal "3e+0"    (toStringWith (exponential 0) pi)
      equal "3.14e+0" (toStringWith (exponential 2) pi)
      equal "3.14e+2" (toStringWith (exponential 2) (100.0 * pi))
      equal "1.2e+3"  (toStringWith (exponential 1) 1234.5)

  suite "Data.Format.toString" do

    test "toString" do
      equal "3.14159" (toString pi)
      equal "10" (toString 10.0)

  suite "Data.Number.Approximate.eqRelative" do
    test "eqRelative" do
      assert "should return true for differences smaller 10%" $
        10.0 ~= 10.9

      assert "should return true for differences smaller 10%" $
        10.0 ~= 9.2

      assertFalse "should return false for differences larger than 10%" $
        10.0 ~= 11.1

      assertFalse "should return false for differences larger than 10%" $
        10.0 ~= 9.01

    test "eqRelative (large numbers)" do
      assert "should return true for differences smaller 10%" $
        100000000000.0 ~= 109000000000.0

      assert "should return true for differences smaller 10%" $
        100000000000.0 ~= 92000000000.0

      assertFalse "should return false for differences larger than 10%" $
        100000000000.0 ~= 111000000000.0

      assertFalse "should return false for differences larger than 10%" $
        100000000000.0 ~= 90000000000.0

    test "eqRelative (small numbers)" do
      assert "should return true for differences smaller 10%" $
        0.000000000001 ~= 0.00000000000109

      assert "should return true for differences smaller 10%" $
        0.000000000001 ~= 0.00000000000092

      assertFalse "should return false for differences larger than 10%" $
        0.000000000001 ~= 0.00000000000111

      assertFalse "should return false for differences larger than 10%" $
        0.000000000001 ~= 0.0000000000009

    test "eqRelative (negative numbers)" do
      assert "should return true for differences smaller 10%" $
        -10.0 ~= -10.9

      assert "should return true for differences smaller 10%" $
        -10.0 ~= -9.2

      assertFalse "should return false for differences larger than 10%" $
        -10.0 ~= -11.1

      assertFalse "should return false for differences larger than 10%" $
        -10.0 ~= -9.01

    test "eqRelative (close or equal to 0.0)" do
      assert "should compare against the fraction if left argument is zero" $
        0.0 ~= 0.0001

      assert "should compare against the fraction if right argument is zero" $
        0.0001 ~= 0.0

      assert "should succeed if both arguments are zero" $
        0.0 ~= 0.0

      assertFalse "should fail if argument is larger than fraction" $
        0.0 ~= 0.11

      assertFalse "should fail if other argument is not exactly zero" $
        1.0e-100 ~= 0.1

    test "eqRelative (fraction = 0.0)" do
      assert "should succeed if numbers are exactly equal" $
        eqRelative (Fraction 0.0) 3.14 3.14

      assertFalse "should fail if numbers are not exactly equal" $
        eqRelative (Fraction 0.0) 3.14 3.14000000000001

    test "eqRelative (fraction > 1.0)" do
      assert "should work for 'fractions' larger than one" $
        eqRelative (Fraction 3.0) 10.0 29.5


  suite "Data.Number.Approximate.eqApproximate" do
    test "0.1 + 0.2 ≅ 0.3" do
      assert "0.1 + 0.2 should be approximately equal to 0.3" $
        0.1 + 0.2 ≅ 0.3

      assert "0.1 + 0.200001 should not be approximately equal to 0.3" $
        0.1 + 0.200001 ≇ 0.3


  suite "Data.Number.Approximate.eqAbsolute" do
    test "eqAbsolute" do
      assert "should succeed for differences smaller than the tolerance" $
        10.0 =~= 10.09

      assert "should succeed for differences smaller than the tolerance" $
        9.91 ~= 10.00

      assertFalse "should fail for differences larger than the tolerance" $
        10.0 =~= 10.11

      assertFalse "should fail for differences larger than the tolerance" $
        9.89 =~= 10.0

    test "eqAbsolute (compare against 0)" do
      assert "should succeed for numbers smaller than the tolerance" $
        0.0 ~= -0.09
