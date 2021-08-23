# purescript-numbers

[![Latest release](http://img.shields.io/github/release/purescript/purescript-numbers.svg)](https://github.com/purescript/purescript-numbers/releases)
[![Build status](https://github.com/purescript/purescript-numbers/workflows/CI/badge.svg?branch=master)](https://github.com/purescript/purescript-numbers/actions?query=workflow%3ACI+branch%3Amaster)
[![Pursuit](https://pursuit.purescript.org/packages/purescript-numbers/badge)](https://pursuit.purescript.org/packages/purescript-numbers)

Utility functions for working with PureScripts builtin `Number` type.

## Installation

```
spago install numbers
```

## Examples

Parsing:

```purs
> fromString "12.34"
(Just 12.34)

> fromString "1e-3"
(Just 0.001)
```

Formatting (`Data.Number.Format`):

```purs
> let x = 1234.56789

> toStringWith (precision 6) x
"1234.57"

> toStringWith (fixed 3) x
"1234.568"

> toStringWith (exponential 2) x
"1.23e+3"
```

Approximate comparisons (`Data.Number.Approximate`):

```purs
> 0.1 + 0.2 == 0.3
false

> 0.1 + 0.2 ≅ 0.3
true
```

_NaN_ and _infinity_:

```purs
> isNaN (Math.asin 2.0)
true

> isFinite (1.0 / 0.0)
false
```

Remainder:
```purs
> 5.3 % 2.0
1.2999999999999998
```

Trignometric functions:
```purs
> sin 0.0
0.0

> cos 0.0
1.0

> tan 0.0
0.0
```

Inverse trignometric functions:
```purs
> asin 0.0
0.0

> acos 0.0 - pi / 2.0
0.0

> atan 0.0
0.0

> atan2 0.0 1.0
0.0
```

Natural logarithm and exponent:
```purs
> log (exp 42.0)
42.0
```

Square root and powers:
```purs
> sqrt (42.0 `pow` 2.0)
42.0
```

Rounding functions:
```purs
> x = 1.5
> ceil x
2.0

> floor x
1.0

> round x
2.0

> trunc x
1.0
```

Numeric minimum and maximum:
```purs
> import Data.Number as Num
> import Data.Ord as Ord
> Num.min 0.0 1.0
0.0

> Num.max 0.0 1.0
1.0

> Num.min Num.nan 0.0
NaN

> Ord.min Num.nan 0.0
0.0
```

Constants:
```purs
> e
2.718281828459045

> ln 2
0.6931471805599453

> ln10
2.302585092994046

> log10e
0.4342944819032518

> log2e
1.4426950408889634

> pi
3.141592653589793

> sqrt1_2
0.7071067811865476

> sqrt2
1.4142135623730951

> tau
6.283185307179586
```

Sign and absolute value:
```purs
> x = -42.0
> sign x * abs x == x
true
```


## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-numbers).
