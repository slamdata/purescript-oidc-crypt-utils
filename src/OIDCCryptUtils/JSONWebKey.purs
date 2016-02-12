module OIDCCryptUtils.JSONWebKey (JSONWebKey()) where

import Prelude (pure, (<<<))
import Data.Argonaut.Core as JS
import Data.Argonaut.Decode as JS

newtype JSONWebKey = JSONWebKey JS.Json

instance decodeJsonJSONWebKey :: JS.DecodeJson JSONWebKey where
  decodeJson = pure <<< JSONWebKey
