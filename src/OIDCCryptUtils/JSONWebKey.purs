module OIDCCryptUtils.JSONWebKey (JSONWebKey()) where

import Prelude (pure, (<<<))
import Data.Argonaut.Core as Argonaut
import Data.Argonaut.Decode as Decode
import Data.Argonaut.Encode as Encode

newtype JSONWebKey = JSONWebKey Argonaut.Json

instance decodeJsonJSONWebKey :: Decode.DecodeJson JSONWebKey where
  decodeJson = pure <<< JSONWebKey

instance encodeJsonJSONWebKey :: Encode.EncodeJson JSONWebKey where
  encodeJson (JSONWebKey json) = Encode.encodeJson json
