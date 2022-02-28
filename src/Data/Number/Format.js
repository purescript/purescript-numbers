function wrap(method) {
  return function(d) {
    return function(num) {
      return method.apply(num, [d]);
    };
  };
}

export var toPrecisionNative = wrap(Number.prototype.toPrecision);
export var toFixedNative = wrap(Number.prototype.toFixed);
export var toExponentialNative = wrap(Number.prototype.toExponential);
export function toString(num) { return num.toString(); }
