# Viper and Vish Bugs

## global statement does not appear to work, but can be made to ...

Make a test for this


```
function foo() { global b; b=3 }
foo
echo :b
```


How it actually does work

```
function se(p1) { a=:p1; global a }
se 22
echo :a
22
```



## Should handle control plus c in Vish REPL.

And also control plus u to delete the contents of the buffer


## The variable :_status is not available in command mode

It works in the ivsh or Vish REPL and inside functions

But not if said functions are executed in command mode


## Comments cannot exist on their won a line in interactive modeAnd in scripts, strange behaviour


```
echo foo
# This is a comment
echo bar baz # trailing comment
echo finished
```


```
echo foo
echo bar
echo baz
# trailing
echo spam
```

Note: spam is not rrun

