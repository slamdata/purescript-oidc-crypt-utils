## Module OIDCCryptUtils.Types

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

#### `runUnhashedNonce`

``` purescript
runUnhashedNonce :: UnhashedNonce -> String
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

#### `runHashedNonce`

``` purescript
runHashedNonce :: HashedNonce -> String
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

#### `runStateString`

``` purescript
runStateString :: StateString -> String
```

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

#### `runBoundStateJWS`

``` purescript
runBoundStateJWS :: BoundStateJWS -> String
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

#### `runIdToken`

``` purescript
runIdToken :: IdToken -> String
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

#### `runIssuer`

``` purescript
runIssuer :: Issuer -> String
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

#### `runClientID`

``` purescript
runClientID :: ClientID -> String
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

#### `runKey`

``` purescript
runKey :: KeyString -> String
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

#### `runKeyId`

``` purescript
runKeyId :: KeyId -> String
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

#### `runEmail`

``` purescript
runEmail :: Email -> String
```


