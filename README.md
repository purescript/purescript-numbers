# purescript-numbers
[![Latest release](http://img.shields.io/github/release/sharkdp/purescript-numbers.svg)](https://github.com/sharkdp/purescript-numbers/releases)
[![Build status](https://travis-ci.org/sharkdp/purescript-numbers.svg?branch=master)](https://travis-ci.org/sharkdp/purescript-numbers)



Functions for working with PureScripts builtin `Number` type.

## Examples

Parsing:
``` purs
> fromString "12.34"
(Just 12.34)

> fromString "1e-3"
(Just 0.001)
```

Approximate comparisons:
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
bower install purescript-numbers
```

## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-numbers).
