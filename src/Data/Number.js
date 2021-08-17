/* globals exports */
"use strict";

exports.nan = NaN;

exports.isNaN = isNaN;

exports.infinity = Infinity;

exports.isFinite = isFinite;

exports.fromStringImpl = function(str, isFinite, just, nothing) {
  var num = parseFloat(str);
  if (isFinite(num)) {
    return just(num);
  } else {
    return nothing;
  }
};

exports.abs = Math.abs;

exports.acos = Math.acos;

exports.asin = Math.asin;

exports.atan = Math.atan;

exports.atan2 = function (y) {
  return function (x) {
    return Math.atan2(y, x);
  };
};

exports.ceil = Math.ceil;

exports.cos = Math.cos;

exports.exp = Math.exp;

exports.floor = Math.floor;

exports.log = Math.log;

exports.max = function (n1) {
  return function (n2) {
    return Math.max(n1, n2);
  };
};

exports.min = function (n1) {
  return function (n2) {
    return Math.min(n1, n2);
  };
};

exports.pow = function (n) {
  return function (p) {
    return Math.pow(n, p);
  };
};

exports.remainder = function (n) {
  return function (m) {
    return n % m;
  };
};

exports.round = Math.round;

signPolyfill = function(x) {
  return x === 0 || x !== x ? x : (x < 0 ? -1 : 1);
}

exports.sign = Math.sign ? Math.sign : exports.signPolyfill;

exports.sin = Math.sin;

exports.sqrt = Math.sqrt;

exports.tan = Math.tan;
