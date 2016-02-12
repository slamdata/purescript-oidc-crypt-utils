// module OIDCCryptUtils

var jsrsasign = require("jsrsasign");

var verifiedNonce = function (nonce) {
  return function (payload) {
    return ("nonce" in payload) ? payload["nonce"] === hashNonce(nonce) : false;
  };
};

var verifiedAud = function (clientId) {
  return function (payload) {
    var aud = ("aud" in payload) ? payload["aud"] : [];

    var arrayAud = Array.isArray(aud);
    var multipleAud = arrayAud && aud.length > 0;
    var clientIdInMultipleAud = (multipleAud) ? aud.indexOf(clientId) !== -1 : false;

    var verifiedAzp = ("azp" in payload) ? payload["azp"] == clientId : true;
    var verifiedSingleAud = aud === clientId;
    var verifiedMultipleAud = verifiedAzp && clientIdInMultipleAud;
    return (verifiedSingleAud || verifiedMultipleAud) && verifiedAzp;
  };
};

var saferReadPayload = function (jwt) {
  try {
    return jsrsasign.jws.JWS.readSafeJSONString(jsrsasign.b64utoutf8(jwt.split(".")[1]));
  } catch (e) {
    return {};
  }
};

var saferVerifyJWT = function (idToken, rsaKey, acceptField) {
  try {
    return jsrsasign.jws.JWS.verifyJWT(idToken, rsaKey, acceptField);
  } catch (e) {
    return false;
  }
};

var hashNonce = function (nonce) {
  return jsrsasign.crypto.Util.md5(nonce);
};

exports.hashNonce = hashNonce;

exports.bindState = function (state) {
  return function (key) {
    return jsrsasign.jws.JWS.sign(null, { alg: "HS256", cty: "JWT" }, state, key);
  };
};

exports._unbindState = function (nothing) {
  return function (just) {
    return function (boundState) {
      return function (key) {
        var boundStatePayload = jsrsasign.b64utoutf8(boundState.split(".")[1]);
        if (jsrsasign.jws.JWS.verify(boundState, key, ['HS256'])) {
          return just(boundStatePayload);
        } else {
          return nothing;
        }
      };
    };
  };
};

exports.verifyIdToken = function (idToken) {
  return function (issuer) {
    return function (clientId) {
      return function (nonce) {
        return function (providerPublicKey) {
          return function () {
            var rsaKey = jsrsasign.KEYUTIL.getKey(providerPublicKey);
            var payload = saferReadPayload(idToken);
            var acceptField = { alg: ["RS256"], iss: [issuer] };
            if (saferVerifyJWT(idToken, rsaKey, acceptField)) {
              return verifiedNonce(nonce)(payload) && verifiedAud(clientId)(payload);
            } else {
              return false;
            }
          };
        };
      };
    };
  };
};
