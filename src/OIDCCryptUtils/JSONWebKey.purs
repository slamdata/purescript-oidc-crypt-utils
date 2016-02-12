module OIDCCryptUtils.JSONWebKey (JSONWebKey()) where

import Prelude (pure, (<<<))
import Data.Argonaut as JS

foreign import
  data JSONWebKey :: *

instance decodeJsonJSONWebKey :: JS.DecodeJson JSONWebKey where
  decodeJson = pure <<< Unsafe.Coerce.unsafeCoerce

