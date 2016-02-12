module OIDCCryptUtils
  ( RSASIGNTIME()
  , hashNonce
  , bindState
  , unbindState
  , verifyIdToken
  , module OIDCCryptUtils.Types
  , module OIDCCryptUtils.JSONWebKey
  ) where

import Control.Monad.Eff (Eff())
import Data.Maybe (Maybe(..))
import OIDCCryptUtils.JSONWebKey
import OIDCCryptUtils.Types

foreign import
  data RSASIGNTIME :: !

foreign import
  hashNonce
    :: UnhashedNonce
    -> HashedNonce

foreign import
  bindState
    :: StateString
    -> KeyString
    -> BoundStateJWS

foreign import
  verifyIdToken
    :: forall eff
     . IdToken
    -> Issuer
    -> ClientID
    -> UnhashedNonce
    -> JSONWebKey
    -> Eff (rsaSignTime :: RSASIGNTIME | eff) Boolean

foreign import
  _unbindState
    :: forall a
     . Maybe a
    -> (a -> Maybe a)
    -> BoundStateJWS
    -> KeyString
    -> Maybe StateString

unbindState
  :: BoundStateJWS
  -> KeyString
  -> Maybe StateString
unbindState = _unbindState Nothing Just
