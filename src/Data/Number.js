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

var formatNumber = function (format) {
  return function (fail, succ, digits, n) {
    try {
      return succ(n[format](digits));
    }
    catch (e) {
      return fail(e.message);
    }
  };
};

exports._toFixed = formatNumber("toFixed");
exports._toExponential = formatNumber("toExponential");
exports._toPrecision = formatNumber("toPrecision");
