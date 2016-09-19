# Troubleshooting

The use of [`remake`](https://github.com/richfitz/remake) and dependent packages is not always obvious. For example, to pass a character literal to a command, [use the `I()` function](https://github.com/richfitz/remake/issues/58). For example,

```r
commands(my_target = my_function(I("character_literal")))
```

Additionally, commands cannot be nested. For example, instead of `commands(my_target = f1(f2(arg)))`, either write

```r
commands(my_target = f1(tmp), tmp = f2(arg))
```

or

```r
commands(my_target = g(arg))
```

where `g(arg)` is just `f1(f2(arg))`.

If you encounter additional problems, please read the [`remake` issues](https://github.com/richfitz/remake/issues) and the [`parallelRemake` issues](https://github.com/wlandau/parallelRemake/issues) first. Bugs and questions can be submitted as [`parallelRemake` issues](https://github.com/wlandau/parallelRemake/issues) as well.
