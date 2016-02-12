module Test.Main where

import Prelude (Unit, bind, (==), (/=))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE(), log)
import Control.Monad.Eff.Exception (EXCEPTION(), throw)
import Data.Maybe (Maybe(..))
import OIDCCryptUtils (RSASIGNTIME(), hashNonce, bindState, unbindState, verifyIdToken)

-- Token generated using https://jwt.io/
-- JWK generated from public PEM using https://www.npmjs.com/package/pem-jwk
-- idToken (and therefore tests) valid until 2050 ; )
idToken :: String
idToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiI5NDU0NzkyNjQyMzMta3Vtc2tvMHEzZTVlaDNlZmQ4cGxsMWRhOWt1YTNpM2IuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhenAiOiI5NDU0NzkyNjQyMzMta3Vtc2tvMHEzZTVlaDNlZmQ4cGxsMWRhOWt1YTNpM2IuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJlbWFpbCI6ImJlY2t5QHNsYW1kYXRhLmNvbSIsImlzcyI6Imh0dHBzOi8vYWNjb3VudHMuZ29vZ2xlLmNvbSIsIm5vbmNlIjoiNWQ0MTQwMmFiYzRiMmE3NmI5NzE5ZDkxMTAxN2M1OTIiLCJleHAiOjI1MjQ2MDgwMDAsImlhdCI6MTQ1NTA2OTM0OCwic3ViIjoiMTA3NjEwNzc2OTUxMDk4NjQzOTUwIn0.PUi5wySBaUSBt9lepycGton2_-plIaX14q19NB13GF8ISa9gUwnt4LeHWPst42jBeAO1GJ_thIYm6gQIIKBMtr0hucddfzu7oWXfobeFke-WwBHgmFIKSccWhI-QoNxmDbJkNolo_oPsu3DcOpFHKrnmrTWuQFZpdYciGpYi72k"

idTokenWithMultipleAudiences :: String
idTokenWithMultipleAudiences = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiYXVkMSIsImF1ZDIiXSwiYXpwIjoiYXVkMSIsImVtYWlsIjoiYmVja3lAc2xhbWRhdGEuY29tIiwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tIiwibm9uY2UiOiI1ZDQxNDAyYWJjNGIyYTc2Yjk3MTlkOTExMDE3YzU5MiIsImV4cCI6MjUyNDYwODAwMCwiaWF0IjoxNDU1MDY5MzQ4LCJzdWIiOiIxMDc2MTA3NzY5NTEwOTg2NDM5NTAifQ.O0bLeKAvB9e22nP_QKuyMnMKBrKDfwbzamgPxc_JXYLoF6cR-goXjPEZytfSR59YZAj6vsVZ-QwTFIY51tGk3qsCwvZw2ynRpMLcjf91FUmNoQvFcDn6Ltp_G9SWcQ_MsWnP9s8WD7AstCUa7E6VSe9nD2Zyazb9BD3iTYzhIrU"

idTokenWithMultipleAudiencesWhichDontMatchTheAzp :: String
idTokenWithMultipleAudiencesWhichDontMatchTheAzp = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiYXVkMSIsImF1ZDIiXSwiYXpwIjoiYXVkMyIsImVtYWlsIjoiYmVja3lAc2xhbWRhdGEuY29tIiwiaXNzIjoiaHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tIiwibm9uY2UiOiI1ZDQxNDAyYWJjNGIyYTc2Yjk3MTlkOTExMDE3YzU5MiIsImV4cCI6MjUyNDYwODAwMCwiaWF0IjoxNDU1MDY5MzQ4LCJzdWIiOiIxMDc2MTA3NzY5NTEwOTg2NDM5NTAifQ.Cs10otwS9hvhYgBZ8yK8Au9Aki7r9OQIFv8o9p9zflPygulaaeLetA3EpJGey9Zm4vyB7hoqhhTx0-2Lv3cop22dp_Ne-X2BF-JoaiddI8I-kVwpm_-hBE2LW3EmGttFgSRZp70-iH65PP1HOiUz1abU8hpfk0VYLjpEJPadYyQ"

azp :: String
azp = "aud1"

state :: String
state = "https://github.com"

stateKey :: String
stateKey = "7cb76d4fa8a18c33906a7d03c6d7d627"

weirdIdToken :: String
weirdIdToken = "70eec61e97a9b0c33abfbd554ae5556a"

issuer :: String
issuer = "https://accounts.google.com"

clientId :: String
clientId = "945479264233-kumsko0q3e5eh3efd8pll1da9kua3i3b.apps.googleusercontent.com"

nonce :: String
nonce = "hello"

publicJWK :: { kty :: String, alg :: String, use :: String, kid :: String, n :: String, e :: String }
publicJWK =
  { kty: "RSA"
  , alg: "RS256"
  , use: "sig"
  , kid: "1"
  , n: "3ZWrUY0Y6IKN1qI4BhxR2C7oHVFgGPYkd38uGq1jQNSqEvJFcN93CYm16_G78FAFKWqwsJb3Wx-nbxDn6LtP4AhULB1H0K0g7_jLklDAHvI8yhOKlvoyvsUFPWtNxlJyh5JJXvkNKV_4Oo12e69f8QCuQ6NpEPl-cSvXIqUYBCs"
  , e: "AQAB"
  }

wrongJWK :: { kty :: String, alg :: String, use :: String, kid :: String, n :: String, e :: String }
wrongJWK =
  { kty: "RSA"
  , e: "AQAB"
  , use: "sig"
  , kid: "1"
  , alg: "RS256"
  , n: "xMX0alhWJsdoKQb3JN_FYD1L2dSgdCtvoaN5iXONgp_W6mEuRK1r7znEpINX_m-qE2hdz-7GT4NQ2x4pUAa-g3xJ7UxCmzIDXe2zxAbvwSBFIPDXBNiP5sUeKE9XmkdUKJ-CJuzy_TGu62kfJvXMdhT5kfeCxsKuaa_QYeOkMl0"
  }

main :: forall e. Eff (console :: CONSOLE, rsaSignTime :: RSASIGNTIME, err :: EXCEPTION | e) Unit
main = do
  if hashNonce nonce == hashNonce nonce
     then log "Equivalent hashed nonces are equal ✔︎"
     else throw "Equivalent hashed nonces aren't equal ✘"

  if hashNonce nonce /= hashNonce "goodbye"
     then log "Non equivalent hashed nonces are not equivalent ✔︎"
     else throw "Non equivalent hashed nonces are equivalent ✘"

  case unbindState (bindState state stateKey) stateKey of
    Just state' ->
      if state' == state
        then log "State succesfully bound and unbound with same key ✔︎"
        else throw "State was unbound using the same key but isn't equivalent to the orignal state ✘"
    Nothing -> throw "State wasn't unbound successfully using same key ✘"

  case unbindState (bindState state stateKey) "Wrong key" of
    Nothing -> log "State wasn't unbound with the wrong key ✔︎"
    Just _ -> throw "State was unbound with the wrong key ✘"

  verified <- verifyIdToken idToken issuer clientId nonce publicJWK
  if verified
     then log "Token was verified with correct key and claims ✔︎"
     else throw "Token was rejected despite correct key and claims ✘"

  verifiedDespiteIncorrectKey <- verifyIdToken idToken issuer clientId nonce wrongJWK
  if verifiedDespiteIncorrectKey
     then throw "Token was verified with incorrect key ✘"
     else log "Token was rejected with incorrect key ✔︎"

  verifiedDespiteWeirdKey <- verifyIdToken weirdIdToken issuer clientId nonce publicJWK
  if verifiedDespiteWeirdKey
     then throw "Token was verified with incorrect key ✘"
     else log "Token was rejected with weird key and didn't leak an exception ✔︎"

  verifiedDespiteIncorrectReplay <- verifyIdToken weirdIdToken issuer clientId "Wrong nonce" publicJWK
  if verifiedDespiteIncorrectReplay
     then throw "Token was verified with incorrect nonce ✘"
     else log "Token was rejected with incorrect nonce ✔︎"

  verifiedDespiteIncorrectAudience <- verifyIdToken idToken issuer "Wrong client id" nonce publicJWK
  if verifiedDespiteIncorrectAudience
     then throw "Token was verified with incorrect client id ✘"
     else log "Token was rejected with incorrect client id ✔︎"

  verifiedDespiteIncorrectIssuer <- verifyIdToken idToken "https://wrongissuer.com" clientId nonce publicJWK
  if verifiedDespiteIncorrectIssuer
     then throw "Token was verified with incorrect issuer ✘"
     else log "Token was rejected with incorrect issuer ✔︎"

  verifiedMultipleAud <- verifyIdToken idTokenWithMultipleAudiences issuer azp nonce publicJWK
  if verifiedMultipleAud
     then log "Token with multiple audiences was verified with correct key and claims ✔︎"
     else throw "Token with multiple audiences was rejected despite correct key and claims ✘"

  verifiedDespiteIncorrectAzp <- verifyIdToken idTokenWithMultipleAudiencesWhichDontMatchTheAzp issuer clientId nonce publicJWK
  if verifiedDespiteIncorrectAzp
     then throw "Token with multiple audiences was verified despite incorrect azp ✘"
     else log "Token with multiple audiences was rejected due to incorrect azp ✔︎"

