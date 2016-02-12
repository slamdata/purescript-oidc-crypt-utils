module OIDCCryptUtils.Types where

import Prelude

newtype UnhashedNonce = UnhashedNonce String
runUnhashedNonce :: UnhashedNonce -> String
runUnhashedNonce (UnhashedNonce s) = s

instance eqUnhashedNonce :: Eq UnhashedNonce where
  eq (UnhashedNonce s) (UnhashedNonce ss) = s == ss
instance ordUnhashedNonce :: Ord UnhashedNonce where
  compare (UnhashedNonce s) (UnhashedNonce ss) = compare s ss


newtype HashedNonce = HashedNonce String
runHashedNonce :: HashedNonce -> String
runHashedNonce (HashedNonce s) = s

instance eqHashedNonce :: Eq HashedNonce where
  eq (HashedNonce s) (HashedNonce ss) = s == ss
instance ordHashedNonce :: Ord HashedNonce where
  compare (HashedNonce s) (HashedNonce ss) = compare s ss


newtype StateString = StateString String
runStateString :: StateString -> String
runStateString (StateString s) = s

instance eqStateString :: Eq StateString where
  eq (StateString s) (StateString ss) = s == ss
instance ordStateString :: Ord StateString where
  compare (StateString s) (StateString ss) = compare s ss


newtype BoundStateJWS = BoundStateJWS String
runBoundStateJWS :: BoundStateJWS -> String
runBoundStateJWS (BoundStateJWS s) = s

instance eqBoundStateJWS :: Eq BoundStateJWS where
  eq (BoundStateJWS s) (BoundStateJWS ss) = s == ss
instance ordBoundStateJWS :: Ord BoundStateJWS where
  compare (BoundStateJWS s) (BoundStateJWS ss) = compare s ss


newtype IdToken = IdToken String
runIdToken :: IdToken -> String
runIdToken (IdToken s) = s

instance eqIdToken :: Eq IdToken where
  eq (IdToken s) (IdToken ss) = s == ss
instance ordIdToken :: Ord IdToken where
  compare (IdToken s) (IdToken ss) = compare s ss


newtype Issuer = Issuer String
runIssuer :: Issuer -> String
runIssuer (Issuer s) = s

instance eqIssuer :: Eq Issuer where
  eq (Issuer s) (Issuer ss) = s == ss
instance ordIssuer :: Ord Issuer where
  compare (Issuer s) (Issuer ss) = compare s ss


newtype ClientID = ClientID String
runClientID :: ClientID -> String
runClientID (ClientID s) = s

instance eqClientID :: Eq ClientID where
  eq (ClientID s) (ClientID ss) = s == ss
instance ordClientID :: Ord ClientID where
  compare (ClientID s) (ClientID ss) = compare s ss


newtype KeyString = KeyString String
runKey :: KeyString -> String
runKey (KeyString s) = s

instance eqKeyString :: Eq KeyString where
  eq (KeyString s) (KeyString ss) = s == ss
instance ordKeyString :: Ord KeyString where
  compare (KeyString s) (KeyString ss) = compare s ss
