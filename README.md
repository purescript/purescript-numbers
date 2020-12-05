# purescript-numbers
[![Latest release](http://img.shields.io/github/release/sharkdp/purescript-numbers.svg)](https://github.com/sharkdp/purescript-numbers/releases)
[![Build status](https://github.com/purescript/purescript-numbers/workflows/CI/badge.svg?branch=master)](https://github.com/purescript/purescript-numbers/actions?query=workflow%3ACI+branch%3Amaster)

Utility functions for working with PureScripts builtin `Number` type.

* [**Module documentation on Pursuit**](http://pursuit.purescript.org/packages/purescript-numbers).

## Examples

Parsing:
``` purs
> fromString "12.34"
(Just 12.34)

> fromString "1e-3"
(Just 0.001)
```

Formatting (`Data.Number.Format`):
``` purs
> let x = 1234.56789

> toStringWith (precision 6) x
"1234.57"

> toStringWith (fixed 3) x
"1234.568"

> toStringWith (exponential 2) x
"1.23e+3"
```

Approximate comparisons (`Data.Number.Approximate`):
``` purs
> 0.1 + 0.2 == 0.3
false

> 0.1 + 0.2 ≅ 0.3
true
```

*NaN* and *infinity*:
``` purs
> isNaN (Math.asin 2.0)
true

> isFinite (1.0 / 0.0)
false
```

## Installation

```
spago install numbers
```


