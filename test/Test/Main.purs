module Test.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)

import Global
  ( readFloat
  , readInt
  , isFinite
  , infinity
  , nan
  , isNaN
  , toPrecision
  , toExponential
  , toFixed
  )
import Global.Unsafe (unsafeToPrecision, unsafeToExponential, unsafeToFixed)

import Test.Assert (assert)

main :: Effect Unit
main = do
  let num = 12345.6789

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

  log "readInt 16 \"0xFF\" == 255.0"
  assert $ readInt 16 "0xFF" == 255.0

  log "readInt 10 \"3.5\" == 3.0"
  assert $ readInt 10 "3.5" == 3.0

  log "readFloat \"3.5\" == 3.5"
  assert $ readFloat "3.5" == 3.5

  -- note the rounding
  log $ "unsafeToFixed 1" <> (show num) <> " == \"12345.7\""
  assert $ unsafeToFixed 1 num == "12345.7"

  -- padded with zeros
  log $ "unsafeToFixed 6" <> (show num) <> " == \"12345.678900\""
  assert $ unsafeToFixed 6 num == "12345.678900"

  log $ "unsafeToExponential 4" <> (show num) <> " == \"1.2346e+4\""
  assert $ unsafeToExponential 4 num == "1.2346e+4"

  log $ "unsafeToPrecision 3" <> (show num) <> " == \"1.23e+4\""
  assert $ unsafeToPrecision 3 num == "1.23e+4"

  log $ "unsafeToPrecision 6" <> (show num) <> " == \"12345.7\""
  assert $ unsafeToPrecision 6 num == "12345.7"

  -- note the rounding
  log $ "toFixed 1" <> (show num) <> " == (Just \"12345.7\")"
  assert $ toFixed 1 num == Just "12345.7"

  -- padded with zeros
  log $ "toFixed 6" <> (show num) <> " == (Just \"12345.678900\")"
  assert $ toFixed 6 num == Just "12345.678900"

  log $ "toExponential 4" <> (show num) <> " == (Just \"1.2346e+4\")"
  assert $ toExponential 4 num == Just "1.2346e+4"

  log $ "toPrecision 3" <> (show num) <> " == (Just \"1.23e+4\")"
  assert $ toPrecision 3 num == Just "1.23e+4"

  log $ "toPrecision 6" <> (show num) <> " == (Just \"12345.7\")"
  assert $ toPrecision 6 num == Just "12345.7"
