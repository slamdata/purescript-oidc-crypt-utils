module OIDC.Crypt
  ( Payload
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

import Prelude (not, when, bind, ($), (<$>), (<<<), (>), (<=))

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Exception as Exception
import Control.Monad.Eff.Now (NOW)
import Control.Monad.Eff.Now as Now

import Data.DateTime.Instant (Instant)
import Data.DateTime.Instant as Instant
import Data.Either (Either)
import Data.Int as Int
import Data.Maybe (Maybe(Just, Nothing), maybe)
import Data.Time.Duration (Seconds(Seconds))
import Data.Time.Duration as Duration

import OIDC.Crypt.JSONWebKey as J
import OIDC.Crypt.Types

foreign import
  data RSAKey :: *

foreign import
  data Header :: *

foreign import
  data Payload :: *

type AcceptedFields
  = { alg :: Array String
    , iss :: Array Issuer
    , gracePeriod :: Seconds
    , verifyAt :: Seconds
    }

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
    -> Eff (err :: EXCEPTION | eff) Boolean

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

foreign import
  _pluckIAT
    :: forall a
     . Maybe a
    -> (a -> Maybe a)
    -> Payload
    -> Maybe Int

foreign import
  _pluckExp
    :: forall a
     . Maybe a
    -> (a -> Maybe a)
    -> Payload
    -> Maybe Int

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

pluckIAT
  :: Payload
  -> Maybe Int
pluckIAT = _pluckIAT Nothing Just

pluckExp
  :: Payload
  -> Maybe Int
pluckExp = _pluckExp Nothing Just

verifyIAT :: Seconds -> Payload -> Boolean
verifyIAT unixTimeNow payload =
  maybe false (_ <= unixTimeNow) (Seconds <<< Int.toNumber <$> pluckIAT payload)

verifyExp :: Seconds -> Payload -> Boolean
verifyExp unixTimeNow payload =
  maybe false (_ > unixTimeNow) (Seconds <<< Int.toNumber <$> pluckExp payload)

instantToSeconds ∷ Instant -> Seconds
instantToSeconds = Duration.convertDuration <<< Instant.unInstant

verifyIdToken
  :: forall eff
   . Seconds
  -> IdToken
  -> Issuer
  -> ClientID
  -> UnhashedNonce
  -> J.JSONWebKey
  -> Eff (now :: NOW | eff) (Either Exception.Error Boolean)
verifyIdToken gracePeriod idToken issuer clientId unhashedNonce providerPublicKey =
  Exception.try do
    payload <- readPayload idToken
    unixTimeNow <- instantToSeconds <$> Now.now
    when
      (not $ verifyNonce unhashedNonce payload)
      (Exception.throw "Nonce doesn't match, possible replay attack.")
    when
      (not $ verifyAudience clientId payload)
      (Exception.throw "Audience (client id) doesn't match.")
    when
      (not $ verifyIAT unixTimeNow payload)
      (Exception.throw "Token issued in the future. Check the time on your computer.")
    when
      (not $ verifyExp unixTimeNow payload)
      (Exception.throw "Token expired.")
    verifyJWT
      idToken
      (getKey providerPublicKey)
      { alg: ["RS256"]
      , iss: [issuer]
      , gracePeriod: gracePeriod
      , verifyAt: unixTimeNow
      }
