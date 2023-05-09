module Test.Main where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Number ((%), abs, acos, asin, atan, atan2, ceil, cos, epsilon, exp, floor, fromString, infinity, isFinite, isNaN, ln10, ln2, log10e, log2e, minPosNumber, maxNumber, nan, pi, pow, round, sign, sin, sqrt, sqrt1_2, sqrt2, tan, tau, trunc)
import Data.Number (log) as Num
import Data.Number.Approximate (Fraction(..), Tolerance(..), eqAbsolute, eqRelative, (≅), (≇))
import Data.Number.Format (precision, fixed, exponential, toStringWith, toString)
import Effect (Effect)
import Effect.Console (log)
import Test.Assert (assert, assertTrue', assertFalse', assertEqual)

main :: Effect Unit
main = do
  globalsTestCode
  numbersTestCode
  numericsTestCode

-- Test code for the `purescript-globals` repo before its' Number-related
-- code was moved into this repo
globalsTestCode :: Effect Unit
globalsTestCode = do
  log "nan /= nan"
  assert $ nan /= nan

  log "not (isNaN 6.0)"
  assert $ not (isNaN 6.0)

  log "isNaN nan"
  assert $ isNaN nan

  log "infinity > 0.0"
  assert $ infinity > 0.0

  log "-infinity < 0.0"
  assert $ -infinity < 0.0

  log "not (isFinite infinity)"
  assert $ not (isFinite infinity)

  log "isFinite 0.0"
  assert $ isFinite 0.0

  log "epsilon equals 2^-52"
  assert $ epsilon == 2.0 `pow` (-52.0)

  log "minPosNumber equals 2^-1074"
  assert $ minPosNumber == 2.0 `pow` (-1074.0)

  log "The sign of minPosNumber is 1.0"
  assert $ sign minPosNumber == 1.0

  log "maxNumber equals 2^1023 * (1 + (1 - 2^-52))"
  assert $ maxNumber == (2.0 `pow` 1023.0) * (1.0 + (1.0 - 2.0 `pow` (-52.0)))

-- Test code originally in this repo before parts of deprecated
-- `purescript-globals` repo was moved to this repo.

-- | Comparison up to 10% relative error.
eqRelative' :: Number -> Number -> Boolean
eqRelative' = eqRelative (Fraction 0.1)

infix 1 eqRelative' as ~=

-- | Comparison up to 0.1 absolute error.
eqAbsolute' :: Number -> Number -> Boolean
eqAbsolute' = eqAbsolute (Tolerance 0.1)

infix 1 eqAbsolute' as =~=

numbersTestCode :: Effect Unit
numbersTestCode = do


  log "Data.Number.fromString"
  log "\tvalid number string"
  assertTrue' "integer strings are coerced" $
    fromMaybe false $ map (_ == 123.0) $ fromString "123"

  assertTrue' "decimals are coerced" $
    fromMaybe false $ map (_ == 12.34) $ fromString "12.34"

  assertTrue' "exponents are coerced" $
    fromMaybe false $ map (_ == 1e4) $ fromString "1e4"

  assertTrue' "decimals exponents are coerced" $
    fromMaybe false $ map (_ == 1.2e4) $ fromString "1.2e4"

  log "\tinvalid number string"
  assertTrue' "invalid strings are not coerced" $
    Nothing == fromString "bad string"

  log "\ttoo large numbers"
  assertTrue' "too large numbers are not coerced" $
    Nothing == fromString "1e1000"

  log "Data.Number.isNaN"
  log "\tCheck for NaN"
  assertTrue' "NaN is not a number" $ isNaN nan
  assertFalse' "infinity is a number" $ isNaN infinity
  assertFalse' "1.0 is a number" $ isNaN 1.0

  log "Data.Number.isFinite"
  log "\tCheck for infinity"
  assertTrue' "1.0e100 is a finite number" $ isFinite 1.0e100
  assertFalse' "detect positive infinity" $ isFinite infinity
  assertFalse' "detect negative infinity" $ isFinite (-infinity)
  assertFalse' "detect NaN" $ isFinite nan

  let pi = 3.14159
  log "Data.Format.toStringWith"

  log "\tprecision"
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

  log "\tfixed"
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

  log "\texponential"
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

  log "Data.Format.toString"

  log "\ttoString"
  assertEqual
    { expected: "3.14159"
    , actual: toString pi
    }

  assertEqual
    { expected: "10"
    , actual: toString 10.0
    }

  log "Data.Number.Approximate.eqRelative"
  log "\teqRelative"
  assertTrue' "should return true for differences smaller 10%" $
    10.0 ~= 10.9

  assertTrue' "should return true for differences smaller 10%" $
    10.0 ~= 9.2

  assertFalse' "should return false for differences larger than 10%" $
    10.0 ~= 11.1

  assertFalse' "should return false for differences larger than 10%" $
    10.0 ~= 9.01

  log "\teqRelative (large numbers)"
  assertTrue' "should return true for differences smaller 10%" $
    100000000000.0 ~= 109000000000.0

  assertTrue' "should return true for differences smaller 10%" $
    100000000000.0 ~= 92000000000.0

  assertFalse' "should return false for differences larger than 10%" $
    100000000000.0 ~= 111000000000.0

  assertFalse' "should return false for differences larger than 10%" $
    100000000000.0 ~= 90000000000.0

  log "\teqRelative (small numbers)"
  assertTrue' "should return true for differences smaller 10%" $
    0.000000000001 ~= 0.00000000000109

  assertTrue' "should return true for differences smaller 10%" $
    0.000000000001 ~= 0.00000000000092

  assertFalse' "should return false for differences larger than 10%" $
    0.000000000001 ~= 0.00000000000111

      -- assertFalse
  assertFalse' "should return false for differences larger than 10%" $
    0.000000000001 ~= 0.0000000000009

  log "\teqRelative (negative numbers)"
  assertTrue' "should return true for differences smaller 10%" $
    -10.0 ~= -10.9

  assertTrue' "should return true for differences smaller 10%" $
    -10.0 ~= -9.2

  assertFalse' "should return false for differences larger than 10%" $
    -10.0 ~= -11.1

  assertFalse' "should return false for differences larger than 10%" $
    -10.0 ~= -9.01

  log "\teqRelative (close or equal to 0.0)"
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

  log "\teqRelative (fraction = 0.0)"
  assertTrue' "should succeed if numbers are exactly equal" $
    eqRelative (Fraction 0.0) 3.14 3.14

  assertFalse' "should fail if numbers are not exactly equal" $
    eqRelative (Fraction 0.0) 3.14 3.14000000000001

  log "\teqRelative (fraction > 1.0)"
  assertTrue' "should work for 'fractions' larger than one" $
    eqRelative (Fraction 3.0) 10.0 29.5


  log "Data.Number.Approximate.eqApproximate"
  log "\t0.1 + 0.2 ≅ 0.3"
  assertTrue' "0.1 + 0.2 should be approximately equal to 0.3" $
    0.1 + 0.2 ≅ 0.3

  assertTrue' "0.1 + 0.200001 should not be approximately equal to 0.3" $
    0.1 + 0.200001 ≇ 0.3


  log "Data.Number.Approximate.eqAbsolute"
  log "\teqAbsolute"
  assertTrue' "should succeed for differences smaller than the tolerance" $
    10.0 =~= 10.09

  assertTrue' "should succeed for differences smaller than the tolerance" $
    9.91 ~= 10.00

  assertFalse' "should fail for differences larger than the tolerance" $
    10.0 =~= 10.11

  assertFalse' "should fail for differences larger than the tolerance" $
    9.89 =~= 10.0

  log "\teqAbsolute (compare against 0)"
  assertTrue' "should succeed for numbers smaller than the tolerance" $
    0.0 ~= -0.09

numericsTestCode :: Effect Unit
numericsTestCode = do
  let assertApproxEqual = \x y -> assert (eqAbsolute (Tolerance 1e-12) x y)
  let pi_4 = pi / 4.0
  let pi_2 = pi / 2.0
  let neg_pi = -pi

  log "Data.Number.sin"
  log "  sin 0.0 = 0.0"
  sin 0.0 `assertApproxEqual` 0.0

  log "  sin (pi / 4.0) = sqrt1_2"
  sin pi_4 `assertApproxEqual` sqrt1_2

  log "  sin (pi / 2.0) = 1.0"
  sin pi_2 `assertApproxEqual` 1.0

  log "  sin pi = 0.0"
  sin pi `assertApproxEqual` 0.0

  log "  sin tau = 0.0"
  sin tau `assertApproxEqual` 0.0

  log "Data.Number.cos"
  log "  cos 0.0 = 1.0"
  cos 0.0 `assertApproxEqual` 1.0

  log "  cos (pi / 4.0) = sqrt1_2"
  cos pi_4 `assertApproxEqual` sqrt1_2

  log "  cos (pi / 2.0) = 0.0"
  cos pi_2 `assertApproxEqual` 0.0

  log "  cos pi = -1.0"
  cos pi `assertApproxEqual` -1.0

  log "  cos tau = 1.0"
  cos tau `assertApproxEqual` 1.0

  log "Data.Number.tan"
  log "  tan 0.0 = 0.0"
  tan 0.0 `assertApproxEqual` 0.0

  log "  tan (pi / 4.0) = 1.0"
  tan pi_4 `assertApproxEqual` 1.0

  log "  tan pi = 0.0"
  tan pi `assertApproxEqual` 0.0

  log "  tan tau = 0.0"
  tan tau `assertApproxEqual` 0.0

  log "Data.Number.asin"
  log "  asin (sin 0.0) = 0.0"
  asin (sin 0.0) `assertApproxEqual` 0.0

  log "  asin (sin pi / 4.0) = pi / 4.0"
  asin (sin pi_4) `assertApproxEqual` pi_4

  log "  asin (sin pi / 2.0) = pi / 2.0"
  asin (sin pi_2) `assertApproxEqual` pi_2

  log "Data.Number.acos"
  log "  acos (cos 0.0) = 0.0"
  acos (cos 0.0) `assertApproxEqual` 0.0

  log "  acos (cos pi / 4.0) = pi / 4.0"
  acos (cos pi_4) `assertApproxEqual` pi_4

  log "  acos (cos pi / 2.0) = pi / 2.0"
  acos (cos pi_2) `assertApproxEqual` pi_2

  log "Data.Number.atan"
  log "  atan (tan 0.0) = 0.0"
  atan (tan 0.0) `assertApproxEqual` 0.0

  log "  atan (tan pi / 4.0) = pi / 4.0"
  atan (tan pi_4) `assertApproxEqual` pi_4

  log "  atan (tan pi / 2.0) = pi / 2.0"
  atan (tan pi_2) `assertApproxEqual` pi_2

  log "Data.Number.atan2"
  log "  atan2 1.0 2.0 = atan (1.0 / 2.0)"
  atan2 1.0 2.0 `assertApproxEqual` atan (1.0 / 2.0)

  log "Data.Number.log"
  log "  log 2.0 = ln2"
  Num.log 2.0 `assertApproxEqual` ln2

  log "  log 10.0 = ln10"
  Num.log 10.0 `assertApproxEqual` ln10

  log "Data.Number.exp"
  log "  exp ln2 = 2.0"
  exp ln2 `assertApproxEqual` 2.0

  log "  exp ln10 = 10.0"
  exp ln10 `assertApproxEqual` 10.0

  log "Data.Number.abs"
  log "  abs pi = pi"
  assert $ abs pi == pi

  log "  abs (-pi) = pi"
  assert $ abs neg_pi == pi

  log "Data.Number.sign"
  log "  sign pi = 1.0"
  assert $ sign pi == 1.0

  log "  sign (-pi) = -1.0"
  assert $ sign neg_pi == -1.0

  log "Data.Number.sqrt"
  log "  sqrt 2.0 = sqrt2"
  sqrt 2.0 `assertApproxEqual` sqrt2

  log "  sqrt (1.0 / 2.0) = sqrt1_2"
  sqrt (1.0 / 2.0) `assertApproxEqual` sqrt1_2

  log "Data.Number.pow"
  log "  2.0 `pow` (1.0 / 2.0) = sqrt2"
  (2.0 `pow` (1.0 / 2.0)) `assertApproxEqual` sqrt2

  log "Data.Number.min"
  log "  min 0.0 1.0 = 0.0"
  assert $ min 0.0 1.0 == 0.0

  log "Data.Number.max"
  log "  max 0.0 1.0 = 1.0"
  assert $ max 0.0 1.0 == 1.0

  log "Data.Number rounding"
  log "  ceil 4.7 = 5.0"
  assert $ ceil 4.7 == 5.0

  log "  floor 4.7 = 4.0"
  assert $ floor 4.7 == 4.0

  log "  round 4.7 = 5.0"
  assert $ round 4.7 == 5.0

  log "  trunc 4.7 = 4.0"
  assert $ trunc 4.7 == 4.0

  log "  ceil (-4.7) = -4.0"
  assert $ ceil (-4.7) == -4.0

  log "  floor (-4.7) = -5.0"
  assert $ floor (-4.7) == -5.0

  log "  round (-4.7) = -5.0"
  assert $ round (-4.7) == -5.0

  log "  trunc (-4.7) = -4.0"
  assert $ trunc (-4.7) == -4.0

  log "  ceil 4.3 = 5.0"
  assert $ ceil 4.3 == 5.0

  log "  floor 4.3 = 4.0"
  assert $ floor 4.3 == 4.0

  log "  round 4.3 = 4.0"
  assert $ round 4.3 == 4.0

  log "  trunc 4.3 = 4.0"
  assert $ trunc 4.3 == 4.0

  log "  ceil (-4.3) = -4.0"
  assert $ ceil (-4.3) == -4.0

  log "  floor (-4.3) = -5.0"
  assert $ floor (-4.3) == -5.0

  log "  round (-4.3) = -4.0"
  assert $ round (-4.3) == -4.0

  log "  trunc (-4.3) = -4.0"
  assert $ trunc (-4.3) == -4.0

  log "Data.Number.remainder (%)"
  log "  12.0 % 5.0 = 2.0"
  assert $ 12.0 % 5.0 == 2.0

  log "  (-12.0) % 5.0 = 2.0"
  assert $ (-12.0) % 5.0 == -2.0

  log "Data.Number constants"
  log "  log10e = 1.0 / ln10"
  log10e `assertApproxEqual` (1.0 / ln10)

  log "  log2e = 1.0 / ln2"
  log2e `assertApproxEqual` (1.0 / ln2)
