# purescript-numbers
Functions for working with PureScript's builtin `Number` type.

## Example

``` purs
> 0.1 + 0.2 == 0.3  
false

> import Data.Number.Approximate 

> Approximate 0.1 + Approximate 0.2 == Approximate 0.3
true
```
