module OIDCCryptUtils.JSONWebKey (JSONWebKey()) where

import Prelude (pure, (<<<))
import Data.Argonaut.Core as JS
import Data.Argonaut.Decode as JSD

newtype JSONWebKey = JSONWebKey JS.Json

instance decodeJsonJSONWebKey :: JSD.DecodeJson JSONWebKey where
  decodeJson = pure <<< JSONWebKey
