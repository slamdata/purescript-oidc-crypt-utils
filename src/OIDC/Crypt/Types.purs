module OIDC.Crypt.Types where

import Prelude
import Data.Argonaut as Argonaut
import Data.Newtype as Newtype

newtype UnhashedNonce = UnhashedNonce String

derive instance newtypeUnhashedNonce :: Newtype.Newtype UnhashedNonce _
derive newtype instance eqUnhashedNonce :: Eq UnhashedNonce
derive newtype instance ordUnhashedNonce :: Ord UnhashedNonce
derive newtype instance encodeJsonUnhashedNonce :: Argonaut.EncodeJson UnhashedNonce
derive newtype instance decodeJsonUnhashedNonce :: Argonaut.DecodeJson UnhashedNonce

newtype HashedNonce = HashedNonce String

derive instance newtypeHashedNonce :: Newtype.Newtype HashedNonce _
derive newtype instance eqHashedNonce :: Eq HashedNonce
derive newtype instance ordHashedNonce :: Ord HashedNonce
derive newtype instance encodeJsonHashedNonce :: Argonaut.EncodeJson HashedNonce
derive newtype instance decodeJsonHashedNonce :: Argonaut.DecodeJson HashedNonce

newtype StateString = StateString String

derive instance newtypeStateString :: Newtype.Newtype StateString _
derive newtype instance eqStateString :: Eq StateString
derive newtype instance ordStateString :: Ord StateString
derive newtype instance encodeJsonStateString :: Argonaut.EncodeJson StateString
derive newtype instance decodeJsonStateString :: Argonaut.DecodeJson StateString

newtype BoundStateJWS = BoundStateJWS String

derive instance newtypeBoundStateJWS :: Newtype.Newtype BoundStateJWS _
derive newtype instance eqBoundStateJWS :: Eq BoundStateJWS
derive newtype instance ordBoundStateJWS :: Ord BoundStateJWS
derive newtype instance encodeJsonBoundStateJWS :: Argonaut.EncodeJson BoundStateJWS
derive newtype instance decodeJsonBoundStateJWS :: Argonaut.DecodeJson BoundStateJWS

newtype IdToken = IdToken String

derive instance newtypeIdToken :: Newtype.Newtype IdToken _
derive newtype instance eqIdToken :: Eq IdToken
derive newtype instance ordIdToken :: Ord IdToken
derive newtype instance encodeJsonIdToken :: Argonaut.EncodeJson IdToken
derive newtype instance decodeJsonIdToken :: Argonaut.DecodeJson IdToken

newtype Issuer = Issuer String

derive instance newtypeIssuer :: Newtype.Newtype Issuer _
derive newtype instance eqIssuer :: Eq Issuer
derive newtype instance ordIssuer :: Ord Issuer
derive newtype instance encodeJsonIssuer :: Argonaut.EncodeJson Issuer
derive newtype instance decodeJsonIssuer :: Argonaut.DecodeJson Issuer

newtype ClientId = ClientId String

derive instance newtypeClientId :: Newtype.Newtype ClientId _
derive newtype instance eqClientId :: Eq ClientId
derive newtype instance ordClientId :: Ord ClientId
derive newtype instance encodeJsonClientId :: Argonaut.EncodeJson ClientId
derive newtype instance decodeJsonClientId :: Argonaut.DecodeJson ClientId

newtype KeyString = KeyString String

derive instance newtypeKeyString :: Newtype.Newtype KeyString _
derive newtype instance eqKeyString :: Eq KeyString
derive newtype instance ordKeyString :: Ord KeyString
derive newtype instance encodeJsonKeyString :: Argonaut.EncodeJson KeyString
derive newtype instance decodeJsonKeyString :: Argonaut.DecodeJson KeyString

newtype KeyId = KeyId String

derive instance newtypeKeyId :: Newtype.Newtype KeyId _
derive newtype instance eqKeyId :: Eq KeyId
derive newtype instance ordKeyId :: Ord KeyId
derive newtype instance encodeJsonKeyId :: Argonaut.EncodeJson KeyId
derive newtype instance decodeJsonKeyId :: Argonaut.DecodeJson KeyId

newtype Email = Email String

derive instance newtypeEmail :: Newtype.Newtype Email _
derive newtype instance eqEmail :: Eq Email
derive newtype instance ordEmail :: Ord Email
derive newtype instance encodeJsonEmail :: Argonaut.EncodeJson Email
derive newtype instance decodeJsonEmail :: Argonaut.DecodeJson Email

