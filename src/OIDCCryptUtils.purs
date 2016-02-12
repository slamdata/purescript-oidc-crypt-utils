module OIDCCryptUtils (RSASIGNTIME(), hashNonce, bindState, unbindState, verifyIdToken) where

import Control.Monad.Eff (Eff())
import Data.Maybe (Maybe(..))

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

-- | IdToken -> Issuer -> ClientID -> UnhashedNonce -> ProviderPublicKeyJWK
foreign import
  verifyIdToken
    :: forall eff rsaKey
     . String
    -> String
    -> String
    -> String
    -> {|rsaKey}
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

