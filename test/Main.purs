module Test.Main where

import Prelude (Unit, bind, (==), (/=), ($))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Exception (EXCEPTION, throw)
import Data.Maybe (Maybe(..))
import OIDC.Crypt
import Data.Either (Either(Right), fromRight)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Parser (jsonParser)
import Partial.Unsafe (unsafePartial)

-- Token generated using https://jwt.io/
-- At http://jwt.io select RS256 and use default public and private PEMs to
-- create new tokens.
-- JWK generated from public PEM using https://www.npmjs.com/package/pem-jwk
-- Id token (and therefore tests) valid until 2050 ; )
idToken :: IdToken
idToken =
  IdToken "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiI5NDU0NzkyNjQyMzMta3Vtc2tvMHEzZTVlaDNlZmQ4cGxsMWRhOWt1YTNpM2IuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhenAiOiI5NDU0NzkyNjQyMzMta3Vtc2tvMHEzZTVlaDNlZmQ4cGxsMWRhOWt1YTNpM2IuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJlbWFpbCI6ImJlY2t5QHNsYW1kYXRhLmNvbSIsImlzcyI6Imh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbSIsIm5vbmNlIjoiNWQ0MTQwMmFiYzRiMmE3NmI5NzE5ZDkxMTAxN2M1OTIiLCJleHAiOjI1MjQ2MDgwMDAsImlhdCI6MTQ1NTA2OTM0OCwic3ViIjoiMTA3NjEwNzc2OTUxMDk4NjQzOTUwIn0.PUi5wySBaUSBt9lepycGton2_-plIaX14q19NB13GF8ISa9gUwnt4LeHWPst42jBeAO1GJ_thIYm6gQIIKBMtr0hucddfzu7oWXfobeFke-WwBHgmFIKSccWhI-QoNxmDbJkNolo_oPsu3DcOpFHKrnmrTWuQFZpdYciGpYi72k"

idTokenWithMultipleAudiences :: IdToken
idTokenWithMultipleAudiences =
  IdToken "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiYXVkMSIsImF1ZDIiXSwiYXpwIjoiYXVkMSIsImVtYWlsIjoiYmVja3lAc2xhbWRhdGEuY29tIiwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tIiwibm9uY2UiOiI1ZDQxNDAyYWJjNGIyYTc2Yjk3MTlkOTExMDE3YzU5MiIsImV4cCI6MjUyNDYwODAwMCwiaWF0IjoxNDU1MDY5MzQ4LCJzdWIiOiIxMDc2MTA3NzY5NTEwOTg2NDM5NTAifQ.O0bLeKAvB9e22nP_QKuyMnMKBrKDfwbzamgPxc_JXYLoF6cR-goXjPEZytfSR59YZAj6vsVZ-QwTFIY51tGk3qsCwvZw2ynRpMLcjf91FUmNoQvFcDn6Ltp_G9SWcQ_MsWnP9s8WD7AstCUa7E6VSe9nD2Zyazb9BD3iTYzhIrU"

idTokenWithMultipleAudiencesWhichDontMatchTheAzp :: IdToken
idTokenWithMultipleAudiencesWhichDontMatchTheAzp =
  IdToken "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiYXVkMSIsImF1ZDIiXSwiYXpwIjoiYXVkMyIsImVtYWlsIjoiYmVja3lAc2xhbWRhdGEuY29tIiwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tIiwibm9uY2UiOiI1ZDQxNDAyYWJjNGIyYTc2Yjk3MTlkOTExMDE3YzU5MiIsImV4cCI6MjUyNDYwODAwMCwiaWF0IjoxNDU1MDY5MzQ4LCJzdWIiOiIxMDc2MTA3NzY5NTEwOTg2NDM5NTAifQ.Cs10otwS9hvhYgBZ8yK8Au9Aki7r9OQIFv8o9p9zflPygulaaeLetA3EpJGey9Zm4vyB7hoqhhTx0-2Lv3cop22dp_Ne-X2BF-JoaiddI8I-kVwpm_-hBE2LW3EmGttFgSRZp70-iH65PP1HOiUz1abU8hpfk0VYLjpEJPadYyQ"

idTokenWithKeyId :: IdToken
idTokenWithKeyId =
  IdToken "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImE0MTYzNjE5NDIzZGNkM2E3MzYxYWNmMmE2NDFiZjZmN2M5ZTQ4OGEifQ.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.NEA7RBDBNfaRjsL4ateAvQ28ovlo-4dM-5W3TISCMYGoAW_qmtJpq2SxsLMgsuXJcwlKXoxJGih5g5YA6b92YA8YpymV-LpTni7niK_STskroFJqB-J75Uc4TX9rJIg1_9AeBiw6nR5ZMLTq3DtpjGCojk-ZUw6Y526UHD0PgMg"

idTokenWithEmail :: IdToken
idTokenWithEmail =
  IdToken "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImVtYWlsIjoiYmVja3lAc2xhbWRhdGEuY29tIn0.prVDiSG7841kXU1NGTbIKG8i8amR21MBzer9Gu3gEo44FxlzKv8o16nchDjiBSdkfZoYjWsryW-y7E3KSfLWRhgN2IWVi0_ias4s5kJ4lLO1RzWx2WLiseG4KgSMnNWB0fMVKSBiZ8zqj5QxyiihAWLEanvdcebIhYwAAuQastQ"

idTokenIssuedInTheFuture :: IdToken
idTokenIssuedInTheFuture =
  IdToken "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiI5NDU0NzkyNjQyMzMta3Vtc2tvMHEzZTVlaDNlZmQ4cGxsMWRhOWt1YTNpM2IuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhenAiOiI5NDU0NzkyNjQyMzMta3Vtc2tvMHEzZTVlaDNlZmQ4cGxsMWRhOWt1YTNpM2IuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJlbWFpbCI6ImJlY2t5QHNsYW1kYXRhLmNvbSIsImlzcyI6Imh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbSIsIm5vbmNlIjoiNWQ0MTQwMmFiYzRiMmE3NmI5NzE5ZDkxMTAxN2M1OTIiLCJleHAiOjI1MjQ2OTQ0MDAsImlhdCI6MjUyNDYwODAwMCwic3ViIjoiMTA3NjEwNzc2OTUxMDk4NjQzOTUwIn0.hLUN9izbGLxaCOaL9x4x9gnO07WtNpHdnoAfP1HzOi3m-xeiyOKrGcVB8Y8PHlfUguhdAfKIzgLRrs_qPPBxlH_KFQnBlrpIE4dE8Jlyvfw6OEgr9V4wDSkxsqntUVE_LPc-L5kKkhHDWrTUS5S08iN2Lm9OYTzlOcyMraWE4As"

expectedKeyId :: KeyId
expectedKeyId = KeyId "a4163619423dcd3a7361acf2a641bf6f7c9e488a"

expectedEmail :: Email
expectedEmail = Email "becky@slamdata.com"

azp :: ClientID
azp =
  ClientID "aud1"

state :: StateString
state =
  StateString "https://github.com"

stateKey :: KeyString
stateKey =
  KeyString "7cb76d4fa8a18c33906a7d03c6d7d627"

weirdIdToken :: IdToken
weirdIdToken =
  IdToken "70eec61e97a9b0c33abfbd554ae5556a"

issuer :: Issuer
issuer =
  Issuer "https://accounts.google.com"

clientId :: ClientID
clientId =
  ClientID "945479264233-kumsko0q3e5eh3efd8pll1da9kua3i3b.apps.googleusercontent.com"

helloNonce :: UnhashedNonce
helloNonce =
  UnhashedNonce "hello"

goodbyeNonce :: UnhashedNonce
goodbyeNonce =
  UnhashedNonce "goodbye"

publicJWKString :: String
publicJWKString =
  "{ \"kty\": \"RSA\", \"alg\": \"RS256\", \"use\": \"sig\", \"kid\": \"1\", \"n\": \"3ZWrUY0Y6IKN1qI4BhxR2C7oHVFgGPYkd38uGq1jQNSqEvJFcN93CYm16_G78FAFKWqwsJb3Wx-nbxDn6LtP4AhULB1H0K0g7_jLklDAHvI8yhOKlvoyvsUFPWtNxlJyh5JJXvkNKV_4Oo12e69f8QCuQ6NpEPl-cSvXIqUYBCs\", \"e\": \"AQAB\"}"

wrongJWKString :: String
wrongJWKString =
  "{ \"kty\": \"RSA\", \"e\": \"AQAB\", \"use\": \"sig\", \"kid\": \"1\", \"alg\": \"RS256\", \"n\": \"xMX0alhWJsdoKQb3JN_FYD1L2dSgdCtvoaN5iXONgp_W6mEuRK1r7znEpINX_m-qE2hdz-7GT4NQ2x4pUAa-g3xJ7UxCmzIDXe2zxAbvwSBFIPDXBNiP5sUeKE9XmkdUKJ-CJuzy_TGu62kfJvXMdhT5kfeCxsKuaa_QYeOkMl0\"}"

publicJWK :: JSONWebKey
publicJWK =
  unsafePartial $ fromRight $ decodeJson $ fromRight $ jsonParser publicJWKString

wrongJWK :: JSONWebKey
wrongJWK =
  unsafePartial $ fromRight $ decodeJson $ fromRight $ jsonParser wrongJWKString

main
  :: forall e
   . Eff (console :: CONSOLE, rsaSignTime :: RSASIGNTIME, err :: EXCEPTION | e) Unit
main = do
  if hashNonce helloNonce == hashNonce helloNonce
     then log "Equivalent hashed nonces are equal ✔︎"
     else throw "Equivalent hashed nonces aren't equal ✘"

  if hashNonce helloNonce /= hashNonce goodbyeNonce
     then log "Non equivalent hashed nonces are not equivalent ✔︎"
     else throw "Non equivalent hashed nonces are equivalent ✘"

  case unbindState (bindState state stateKey) stateKey of
    Just state' ->
      if state' == state
        then log "State succesfully bound and unbound with same key ✔︎"
        else throw "State was unbound using the same key but isn't equivalent to the orignal state ✘"
    Nothing -> throw "State wasn't unbound successfully using same key ✘"

  case unbindState (bindState state stateKey) (KeyString "Wrong key") of
    Nothing -> log "State wasn't unbound with the wrong key ✔︎"
    Just _ -> throw "State was unbound with the wrong key ✘"

  headerWithKeyId <- readHeader idTokenWithKeyId
  case pluckKeyId headerWithKeyId of
    Just keyId ->
      if keyId == expectedKeyId
        then log "Key id succesfully plucked ✔︎"
        else throw "Incorrect key id plucked ✘"
    Nothing -> throw "Key id wasn't plucked ✘"

  headerWithEmail <- readHeader idTokenWithEmail
  case pluckKeyId headerWithEmail of
    Nothing -> log "Key id wasn't plucked when there wasn't one there ✔︎"
    Just keyId -> throw "A key id was plucked somehow even though its not in the token ✘"

  payloadWithEmail <- readPayload idTokenWithEmail
  case pluckEmail payloadWithEmail of
    Just email ->
      if email == expectedEmail
        then log "Email succesfully plucked ✔︎"
        else throw "Incorrect email plucked ✘"
    Nothing -> throw "Email wasn't plucked ✘"

  payloadWithKeyId <- readPayload idTokenWithKeyId
  case pluckEmail payloadWithKeyId of
    Nothing -> log "Email wasn't plucked when there wasn't one there ✔︎"
    Just email -> throw "An email was plucked somehow even though its not in the token ✘"

  verified <-
    verifyIdToken
      idToken
      issuer
      clientId
      helloNonce
      publicJWK
  case verified of
     Right true -> log "Token was verified with correct key and claims ✔︎"
     _ -> throw "Token was rejected despite correct key and claims ✘"

  verifiedDespiteIncorrectKey <-
    verifyIdToken
      idToken
      issuer
      clientId
      helloNonce
      wrongJWK
  case verifiedDespiteIncorrectKey of
     Right true -> throw "Token was verified with incorrect key ✘"
     _ -> log "Token was rejected with incorrect key ✔︎"

  verifiedDespiteWeirdKey <-
    verifyIdToken
      weirdIdToken
      issuer
      clientId
      helloNonce
      publicJWK
  case verifiedDespiteWeirdKey of
     Right true -> throw "Incorrect token was verified ✘"
     _ -> log "Token was rejected with weird key and didn't leak an exception ✔︎"

  verifiedDespiteIncorrectReplay <-
    verifyIdToken
      idToken
      issuer
      clientId
      goodbyeNonce
      publicJWK
  case verifiedDespiteIncorrectReplay of
     Right true -> throw "Token was verified with incorrect nonce ✘"
     _ -> log "Token was rejected with incorrect nonce ✔︎"

  verifiedDespiteIncorrectAudience <-
    verifyIdToken
      idToken
      issuer
      (ClientID "Wrong client id")
      helloNonce
      publicJWK
  case verifiedDespiteIncorrectAudience of
     Right true -> throw "Token was verified with incorrect client id ✘"
     _ -> log "Token was rejected with incorrect client id ✔︎"

  verifiedDespiteIncorrectIssuer <-
    verifyIdToken
      idToken
      (Issuer "https://wrongissuer.com")
      clientId
      helloNonce
      publicJWK
  case verifiedDespiteIncorrectIssuer of
     Right true -> throw "Token was verified with incorrect issuer ✘"
     _ -> log "Token was rejected with incorrect issuer ✔︎"

  verifiedMultipleAud <-
    verifyIdToken
      idTokenWithMultipleAudiences
      issuer
      azp
      helloNonce
      publicJWK
  case verifiedMultipleAud of
     Right true -> log "Token with multiple audiences was verified with correct key and claims ✔︎"
     _ -> throw "Token with multiple audiences was rejected despite correct key and claims ✘"

  verifiedDespiteIncorrectAzp <-
    verifyIdToken
      idTokenWithMultipleAudiencesWhichDontMatchTheAzp
      issuer
      clientId
      helloNonce
      publicJWK
  case verifiedDespiteIncorrectAzp of
     Right true -> throw "Token with multiple audiences was verified despite incorrect azp ✘"
     _ -> log "Token with multiple audiences was rejected due to incorrect azp ✔︎"

  verifiedDespiteBeingIssuedInTheFuture <-
    verifyIdToken
      idTokenIssuedInTheFuture
      issuer
      clientId
      helloNonce
      publicJWK
  case verifiedDespiteBeingIssuedInTheFuture of
     Right true -> throw "Token was verified despite being issued in the future ✘"
     _ -> log "Token was rejected due to being issued in the future ✔︎"
