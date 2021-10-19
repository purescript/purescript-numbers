/* globals exports */
"use strict";

exports.epsilon = Number.EPSILON;

exports.nan = NaN;

exports.isNaN = isNaN;

exports.infinity = Infinity;

exports.negativeInfinity = Number.NEGATIVE_INFINITY;

exports.isFinite = isFinite;

exports.fromStringImpl = function(str, isFinite, just, nothing) {
  var num = parseFloat(str);
  if (isFinite(num)) {
    return just(num);
  } else {
    return nothing;
  }
};

exports.maxValue = Number.MAX_VALUE;

exports.minValue = Number.MIN_VALUE;
