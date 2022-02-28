/* globals exports */
export {NaN as nan};
export {isNaN};
export {Infinity as infinity};
export {isFinite};

export function fromStringImpl(str, isFinite, just, nothing) {
  var num = parseFloat(str);
  if (isFinite(num)) {
    return just(num);
  } else {
    return nothing;
  }
}
