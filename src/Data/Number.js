/* globals exports */
export const nan = NaN;
const isNaNImpl = isNaN;
export { isNaNImpl as isNaN };
export const infinity = Infinity;
const isFiniteImpl = isFinite;
export { isFiniteImpl as isFinite };

export function fromStringImpl(str, isFinite, just, nothing) {
  var num = parseFloat(str);
  if (isFinite(num)) {
    return just(num);
  } else {
    return nothing;
  }
}
