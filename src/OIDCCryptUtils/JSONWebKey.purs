module OIDCCryptUtils.JSONWebKey (JSONWebKey()) where

import Prelude (pure, (<<<))
import Data.Argonaut.Core as JS
import Data.Argonaut.Decode as JSD
import Data.Argonaut.Encode as JSE

newtype JSONWebKey = JSONWebKey JS.Json

instance decodeJsonJSONWebKey :: JSD.DecodeJson JSONWebKey where
  decodeJson = pure <<< JSONWebKey

instance encodeJsonJSONWebKey :: JSE.EncodeJson JSONWebKey where
  encodeJson (JSONWebKey json) = JSE.encodeJson json
