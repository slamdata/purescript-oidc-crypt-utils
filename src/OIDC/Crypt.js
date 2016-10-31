"use strict";

var jsrsasign = require("jsrsasign");

// Effectful

exports.readPayload = function (jwt) {
  return function () {
    return jsrsasign.jws.JWS.readSafeJSONString(jsrsasign.b64utoutf8(jwt.split(".")[1]));
  };
};

exports.readHeader = function (jwt) {
  return function () {
    return jsrsasign.jws.JWS.readSafeJSONString(jsrsasign.b64utoutf8(jwt.split(".")[0]));
  };
};

exports.verifyJWT = function (idToken) {
  return function (rsaKey) {
    return function (acceptedFields) {
      return function () {
        return jsrsasign.jws.JWS.verifyJWT(idToken, rsaKey, acceptedFields);
      };
    };
  };
};

// Uneffectful

exports.hashNonce = function (nonce) {
  return jsrsasign.crypto.Util.md5(nonce);
};

exports.bindState = function (state) {
  return function (key) {
    return jsrsasign.jws.JWS.sign(null, { alg: "HS256", cty: "JWT" }, state, key);
  };
};

exports.getKey = jsrsasign.KEYUTIL.getKey;

exports.verifyNonce = function (unhashedNonce) {
  return function (payload) {
    return "nonce" in payload ? payload.nonce === exports.hashNonce(unhashedNonce) : false;
  };
};

exports.verifyAudience = function (clientId) {
  return function (payload) {
    var aud = "aud" in payload ? payload.aud : [];

    var arrayAud = Array.isArray(aud);
    var multipleAud = arrayAud && aud.length > 0;
    var clientIdInMultipleAud = multipleAud ? aud.indexOf(clientId) !== -1 : false;

    var verifiedAzp = "azp" in payload ? payload.azp === clientId : true;
    var verifiedSingleAud = aud === clientId;
    var verifiedMultipleAud = verifiedAzp && clientIdInMultipleAud;
    return (verifiedSingleAud || verifiedMultipleAud) && verifiedAzp;
  };
};

exports._unbindState = function (nothing) {
  return function (just) {
    return function (boundState) {
      return function (key) {
        var boundStatePayload = jsrsasign.b64utoutf8(boundState.split(".")[1]);
        if (jsrsasign.jws.JWS.verify(boundState, key, ["HS256"])) {
          return just(boundStatePayload);
        } else {
          return nothing;
        }
      };
    };
  };
};

exports._pluckEmail = function (nothing) {
  return function (just) {
    return function (payload) {
      return "email" in payload ? just(payload.email) : nothing;
    };
  };
};

exports._pluckKeyId = function (nothing) {
  return function (just) {
    return function (header) {
      return "kid" in header ? just(header.kid) : nothing;
    };
  };
};
