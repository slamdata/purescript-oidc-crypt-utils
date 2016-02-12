module OIDCCryptUtils (RSASIGNTIME(), hashNonce, bindState, unbindState, verifyIdToken) where

import Control.Monad.Eff (Eff())
import Data.Maybe (Maybe(..))
import OIDCCryptUtils.JSONWebKey (JSONWebKey())

foreign import
  data RSASIGNTIME :: !

-- | UnhashedNonce -> HashedNonce
foreign import
  hashNonce
    :: String
    -> String

-- | StateString -> AnyString -> BoundStateJWS
foreign import
  bindState
    :: String
    -> String
    -> String

-- | IdToken -> Issuer -> ClientID -> UnhashedNonce -> ProviderPublicKeyJWK -> Eff (...) Boolean
foreign import
  verifyIdToken
    :: forall eff
     . String
    -> String
    -> String
    -> String
    -> JSONWebKey
    -> Eff (rsaSignTime :: RSASIGNTIME | eff) Boolean

foreign import
  _unbindState
    :: Maybe String
    -> (String -> Maybe String)
    -> String
    -> String
    -> Maybe String

-- | BoundStateJWS -> AnyString -> Maybe StateString
unbindState
  :: String
  -> String
  -> Maybe String
unbindState = _unbindState Nothing Just

