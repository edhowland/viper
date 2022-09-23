# Wont fix


## 2022-09-22



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



## The variable :_status is not available in command mode

It works in the ivsh or Vish REPL and inside functions

But not if said functions are executed in command mode



The reason for wontfix is: This only gets in scripts/003_command.vsh
in the capture block for the REPL. It is handy for exception debugging. If some function raised an exception
you can inspect the last status of the preceeding command.
