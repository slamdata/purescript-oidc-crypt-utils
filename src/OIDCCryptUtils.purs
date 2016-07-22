module OIDCCryptUtils
  ( RSASIGNTIME()
  , hashNonce
  , bindState
  , unbindState
  , verifyIdToken
  , pluckKeyId
  , pluckEmail
  , module OIDCCryptUtils.Types
  , module J
  ) where

import Control.Monad.Eff (Eff())
import Data.Maybe (Maybe(..))
import OIDCCryptUtils.JSONWebKey as J
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
    -> J.JSONWebKey
    -> Eff (rsaSignTime :: RSASIGNTIME | eff) Boolean

foreign import
  _unbindState
    :: forall a
     . Maybe a
    -> (a -> Maybe a)
    -> BoundStateJWS
    -> KeyString
    -> Maybe StateString

foreign import
  _pluckKeyId
    :: forall a
     . Maybe a
    -> (a -> Maybe a)
    -> IdToken
    -> Maybe KeyId

foreign import
  _pluckEmail
    :: forall a
     . Maybe a
    -> (a -> Maybe a)
    -> IdToken
    -> Maybe Email

unbindState
  :: BoundStateJWS
  -> KeyString
  -> Maybe StateString
unbindState = _unbindState Nothing Just

pluckKeyId
  :: IdToken
  -> Maybe KeyId
pluckKeyId = _pluckKeyId Nothing Just

pluckEmail
  :: IdToken
  -> Maybe Email
pluckEmail = _pluckEmail Nothing Just
