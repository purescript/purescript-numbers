/* globals exports */
export const nan = NaN;
export const isNaN = isNaN;
export const infinity = Infinity;
export const isFinite = isFinite;

export function fromStringImpl(str, isFinite, just, nothing) {
  var num = parseFloat(str);
  if (isFinite(num)) {
    return just(num);
  } else {
    return nothing;
  }
}
