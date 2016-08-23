module Test.Main where

import Prelude

import Data.Number (eqRelative, eqAbsolute)
import Data.Number.Approximate (Approximate(..))

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


  suite "Approximate" do
    let x = Approximate 0.3
        y = Approximate 0.2999999999
        a = Approximate 0.1
        b = Approximate 0.2

    test "Eq instance" do
      assert "should treat them as equal" $
        x == y

    test "Ord instance" do
      assert "should also treat them as equal" $
        x >= y && y >= x

    test "Addition" do
      assert "0.1 + 0.2 should be equal to 0.3 (with Approximate)" $
        a + b == x

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
