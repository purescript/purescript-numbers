module Test.Main where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number (eqRelative, eqAbsolute, fromString, (≅), (≇))

import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)

import Test.Unit (suite, test)
import Test.Unit.Assert (assert, assertFalse)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (runTest)


-- | Comparison up to 10% relative error.
eqRelative' ∷ Number → Number → Boolean
eqRelative' = eqRelative 0.1

infix 1 eqRelative' as ~=

-- | Comparison up to 0.1 absolute error.
eqAbsolute' ∷ Number → Number → Boolean
eqAbsolute' = eqAbsolute 0.1

infix 1 eqAbsolute' as =~=

main ∷ Eff (console ∷ CONSOLE, testOutput ∷ TESTOUTPUT, avar ∷ AVAR) Unit
main = runTest do

  suite "eqRelative" do
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
        eqRelative 0.0 3.14 3.14

      assertFalse "should fail if numbers are not exactly equal" $
        eqRelative 0.0 3.14 3.14000000000001

    test "eqRelative (fraction > 1.0)" do
      assert "should work for 'fractions' larger than one" $
        eqRelative 3.0 10.0 29.5


  suite "eqApproximate" do
    test "0.1 + 0.2 ≅ 0.3" do
      assert "0.1 + 0.2 should be approximately equal to 0.3" $
        0.1 + 0.2 ≅ 0.3

      assert "0.1 + 0.200001 should not be approximately equal to 0.3" $
        0.1 + 0.200001 ≇ 0.3


  suite "fromString" do
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


  suite "eqAbsolute" do
    test "eqAbsolute" do
      assert "should succeed for differences smaller than the precision" $
        10.0 =~= 10.09

      assert "should succeed for differences smaller than the precision" $
        9.91 ~= 10.00

      assertFalse "should fail for differences larger than the precision" $
        10.0 =~= 10.11

      assertFalse "should fail for differences larger than the precision" $
        9.89 =~= 10.0

    test "eqAbsolute (compare against 0)" do
      assert "should succeed for numbers smaller than the precision" $
        0.0 ~= -0.09
