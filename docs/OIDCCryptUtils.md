## Module OIDCCryptUtils

#### `RSASIGNTIME`

``` purescript
data RSASIGNTIME :: !
```

#### `hashNonce`

``` purescript
hashNonce :: UnhashedNonce -> HashedNonce
```

#### `bindState`

``` purescript
bindState :: StateString -> KeyString -> BoundStateJWS
```

#### `verifyIdToken`

``` purescript
verifyIdToken :: forall eff. IdToken -> Issuer -> ClientID -> UnhashedNonce -> JSONWebKey -> Eff (rsaSignTime :: RSASIGNTIME | eff) Boolean
```

#### `unbindState`

``` purescript
unbindState :: BoundStateJWS -> KeyString -> Maybe StateString
```

#### `pluckKeyId`

``` purescript
pluckKeyId :: IdToken -> Maybe KeyId
```

#### `pluckEmail`

``` purescript
pluckEmail :: IdToken -> Maybe Email
```


### Re-exported from OIDCCryptUtils.JSONWebKey:

#### `JSONWebKey`

``` purescript
newtype JSONWebKey
```

##### Instances
``` purescript
DecodeJson JSONWebKey
```

### Re-exported from OIDCCryptUtils.Types:

#### `BoundStateJWS`

``` purescript
newtype BoundStateJWS
  = BoundStateJWS String
```

##### Instances
``` purescript
Eq BoundStateJWS
Ord BoundStateJWS
```

#### `ClientID`

``` purescript
newtype ClientID
  = ClientID String
```

##### Instances
``` purescript
Eq ClientID
Ord ClientID
```

#### `Email`

``` purescript
newtype Email
  = Email String
```

##### Instances
``` purescript
Eq Email
Ord Email
```

#### `HashedNonce`

``` purescript
newtype HashedNonce
  = HashedNonce String
```

##### Instances
``` purescript
Eq HashedNonce
Ord HashedNonce
```

#### `IdToken`

``` purescript
newtype IdToken
  = IdToken String
```

##### Instances
``` purescript
Eq IdToken
Ord IdToken
```

#### `Issuer`

``` purescript
newtype Issuer
  = Issuer String
```

##### Instances
``` purescript
Eq Issuer
Ord Issuer
```

#### `KeyId`

``` purescript
newtype KeyId
  = KeyId String
```

##### Instances
``` purescript
Eq KeyId
Ord KeyId
```

#### `KeyString`

``` purescript
newtype KeyString
  = KeyString String
```

##### Instances
``` purescript
Eq KeyString
Ord KeyString
```

#### `StateString`

``` purescript
newtype StateString
  = StateString String
```

##### Instances
``` purescript
Eq StateString
Ord StateString
```

#### `UnhashedNonce`

``` purescript
newtype UnhashedNonce
  = UnhashedNonce String
```

##### Instances
``` purescript
Eq UnhashedNonce
Ord UnhashedNonce
```

#### `runBoundStateJWS`

``` purescript
runBoundStateJWS :: BoundStateJWS -> String
```

#### `runClientID`

``` purescript
runClientID :: ClientID -> String
```

#### `runEmail`

``` purescript
runEmail :: Email -> String
```

#### `runHashedNonce`

``` purescript
runHashedNonce :: HashedNonce -> String
```

#### `runIdToken`

``` purescript
runIdToken :: IdToken -> String
```

#### `runIssuer`

``` purescript
runIssuer :: Issuer -> String
```

#### `runKey`

``` purescript
runKey :: KeyString -> String
```

#### `runKeyId`

``` purescript
runKeyId :: KeyId -> String
```

#### `runStateString`

``` purescript
runStateString :: StateString -> String
```

#### `runUnhashedNonce`

``` purescript
runUnhashedNonce :: UnhashedNonce -> String
```

