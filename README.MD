# lua-resty-valid

a simple valid lib for Openresty

Features:

- valid string length
- valid number range
- valid ipv4 format (with pure lua's Patterns or openresty's PCRE)
- valid element in the given list

# Synopsis

```lua
local va = require("resty.valid")

-- string
va.string("a") -- return true
va.string("a",{len=4}) -- return nil
va.string("a",{min=1,max=4}) -- return true

-- number
va.number(1) --return true
va.number(1,{min=1,max=5}) -- return true
va.number(1,{min=2,max=5}) -- return nil

-- ipv4
-- use PCRE(default)
va.ipv4("1.1.1.1")  --return true
va.ipv4("a.b.c.d")  --return nil
va.ipv4("1.1.1.1",{regex = "pcre",priv = true,}) -- return nil
va.ipv4("1.1.1.1",{regex = "pcre"}) -- return true
-- use orig
va.ipv4("1.1.1.1",{regex = "orig"}) --return true
va.ipv4("a.b.c.d",{regex = "orig"}) -- return nil

-- choice
va.choice("apple",{"banana","perl","apple"}) --return true
va.choice("apple",{"banana","perl","apple1"}) --return nil


```

# Installation

With [LuaRocks](https://luarocks.org/):

```
luarocks install --server=http://luarocks.org/dev lua-resty-valid
```

# Methods

## string

**syntax:** `result, err = va.string(arg, opts?)`

Valid the string.If failed return `nil` and a string describing the error.

The first argument `arg` is the target you want to valid.

The second argument `opts` is optional.If provided, it must be a table holding the desired options for this instance. The possible options are:

- `len`：a number defined the string length of the given `arg` 

- `min` and `max`：a range defined the string length range between the `min` and `max`. 

## number

**syntax:** `result, err = va.number(arg, opts?)`

Valid the number.If failed return `nil` and a string describing the error.

The first argument `arg` is the target  you want to valid.

The second argument `opts` is optional.If provided, it must be a table holding the desired options for this instance. The possible options are:

- `min` and `max`：a range defined the number should in

## ipv4

**syntax:** `result, err = va.ipv4(arg, opts?)`

Valid the ipv4 format.If failed return `nil` and a string describing the error.

The first argument `arg` is the target  you want to valid.

The second argument `opts` is optional.If provided, it must be a table holding the desired options for this instance. The possible options are:

- `regex`：what the regex system to use. 

  regex system can use both `pcre` (only in openresty env)and `orig` (as pure lua).

  the `pcre` will use `jo`options，as the `ngx.re.find`method's options.

  the `orig`  due to the lua's  Patterns, have some reliability problems.for most of the time,should use `pcre` first 

  **Default：**`pcre`

- `priv`: check if the given ip in the private IP range.Only work with the `perc` regex system.When specified，the `regex` must specified together.

## choice

**syntax:** `result, err = va.choice(arg, choices)`

Valid the if arg in the choices table If failed return `nil` and a string describing the error.

The first argument `arg` is the target you want to valid.

The second argument `choices` is a array table,that contain all the choices.

# License

Work licensed under the MIT License.