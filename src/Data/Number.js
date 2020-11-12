/* globals exports */
"use strict";

exports.nan = NaN;

exports.isNaN = isNaN;

exports.infinity = Infinity;

exports.isFinite = isFinite;

exports.readFloat = parseFloat;

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
