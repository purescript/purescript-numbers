exports.fromStringImpl = function (just) {
  return function (nothing) {
    return function (string) {
      var result = parseFloat(string);

      return isNaN(result) ? nothing
                           : just(result);
    };
  };
};
