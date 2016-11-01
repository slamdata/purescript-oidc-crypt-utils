module OIDC.Crypt
  ( RSASIGNTIME
  , Payload
  , Header
  , hashNonce
  , bindState
  , unbindState
  , verifyIdToken
  , pluckKeyId
  , pluckEmail
  , readHeader
  , readPayload
  , module OIDC.Crypt.Types
  , module J
  ) where

import Control.Applicative (when)
import Control.Bind ((=<<))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Exception as Exception
import Data.Either (Either)
import Data.Maybe (Maybe(Just, Nothing))
import OIDC.Crypt.JSONWebKey as J
import OIDC.Crypt.Types
import Prelude (bind, not, (<<<), ($), (&&))

foreign import
  data RSASIGNTIME :: !

foreign import
  data RSAKey :: *

foreign import
  data Header :: *

foreign import
  data Payload :: *

type AcceptedFields = { alg :: Array String, iss :: Array Issuer }

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
  getKey
    :: J.JSONWebKey
    -> RSAKey

foreign import
  verifyJWT
    :: forall eff
     . IdToken
    -> RSAKey
    -> AcceptedFields
    -> Eff (err :: EXCEPTION, rsaSignTime :: RSASIGNTIME | eff) Boolean

foreign import
  readPayload
    :: forall eff
     . IdToken
    -> Eff (err :: EXCEPTION | eff) Payload

foreign import
  readHeader
    :: forall eff
     . IdToken
    -> Eff (err :: EXCEPTION | eff) Header

foreign import
  verifyNonce
    :: UnhashedNonce
    -> Payload
    -> Boolean

foreign import
  _unbindState
    :: forall a
     . Maybe a
    -> (a -> Maybe a)
    -> BoundStateJWS
    -> KeyString
    -> Maybe StateString

foreign import
  verifyAudience
    :: ClientID
    -> Payload
    -> Boolean

foreign import
  _pluckKeyId
    :: forall a
     . Maybe a
    -> (a -> Maybe a)
    -> Header
    -> Maybe KeyId

foreign import
  _pluckEmail
    :: forall a
     . Maybe a
    -> (a -> Maybe a)
    -> Payload
    -> Maybe Email

unbindState
  :: BoundStateJWS
  -> KeyString
  -> Maybe StateString
unbindState = _unbindState Nothing Just

pluckKeyId
  :: Header
  -> Maybe KeyId
pluckKeyId = _pluckKeyId Nothing Just

pluckEmail
  :: Payload
  -> Maybe Email
pluckEmail = _pluckEmail Nothing Just

verifyIdToken
  :: forall eff
   . IdToken
  -> Issuer
  -> ClientID
  -> UnhashedNonce
  -> J.JSONWebKey
  -> Eff (rsaSignTime :: RSASIGNTIME | eff) (Either Exception.Error Boolean)
verifyIdToken idToken issuer clientId unhashedNonce providerPublicKey =
  Exception.try do
    payload <- readPayload idToken
    when
      (not $ verifyNonce unhashedNonce payload)
      (Exception.throw "Nonce doesn't match, possible replay attack.")
    when
      (not $ verifyAudience clientId payload)
      (Exception.throw "Audience (client id) doesn't match.")
    verifyJWT idToken (getKey providerPublicKey) { alg: ["RS256"], iss: [issuer] }
