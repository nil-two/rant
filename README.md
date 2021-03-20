rant
====

Generate a random text from the expression.

```
$ rant
8gYmRa3F

$ rant -e '[Vv]im ?[sS]cript' -c 5
vimScript
vimscript
vim Script
vim script
vimScript
```

Usage
-----

```
$ rant [<option(s)>] <expression-only-if-no-other-expression>
generate a random text from the expression

options:
  -c, --count=N           generate random text N times
  -e, --expression=EXPR   generate random text from EXPR
  -s, --separator=SEP     print SEP between the generated text
      --help              print usage and exit

expression-syntax:
  \d    digit character
  \w    alphanumeric character + "_"
  \t    tab character
  \n    newline character
  [...] character list ([abc], [a-z] and [a-zA-Z] are supported)
  \x    escape x
  {n,m} repeat n to m times (m is optional)
  ?     same as {0,1}
  (a|b) a or b
```

Requirements
------------

- Perl (5.8.0 or later)

Installation
------------

1. Copy `rant` into your `$PATH`.
2. Make `rant` executable.

### Example

```
$ curl -L https://raw.githubusercontent.com/kusabashira/rant/master/rant > ~/bin/rant
$ chmod +x ~/bin/rant
```

Note: In this example, `$HOME/bin` must be included in `$PATH`.

Options
-------

### -c, --count=N

Generate random text N times (default: 1)

```
$ rant -c 3
L77fQz2T
yVuO0hQu
RnA5CsT2
```

### -e, --expression=EXPR

Generate random text from EXPR (default: \w{8})
If this option specified, first arguments ignored.

```
$ rant -e'(Good morning|Hello|Good afternoon)'
Good afternoon

$ rant -e'1: \|{1,20}' -c5
1: ||||||||||||
1: |||||||||
1: |||
1: ||||||
1: ||||||||||||||||
```

###  -s, --separator=SEP

Print SEP between the generated text (default: \n)

```
$ rant -c5 -s,
8HurMlUi,0Avlt4JQ,WGxKzlE5,1blwOZJ2,LbiHLV3l

$ rant -e'([01](,[01]){2})' -c5 -s/
1,1,0/1,1,0/0,0,0/1,1,0/1,0,1
```

### --help

Print usage and exit.

```
$ rant --help
(Print usage and exit)
```

License
-------

MIT License

Author
------

nil2 <nil2@nil2.org>
