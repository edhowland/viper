# Wont fix

## 2022-11-09

- abbreviations: Work on the Vish command line
  * inspired by abbreviations in the Fish shell


## 2022-11-03

## The read command does not handle multi-line stdin

```
(echo hello; echo world)
hello
world
(echo hello; echo world) | read r1 r2
echo :r1
hello
echo :r2

```

Wontfix: The current behaviour of the Vish read command matches the behaviour of Bassh read command

To change the behaviour of the read command in bash, you need to pass  the '-d <char>' option.
By default, the read command in Bash terminates on the  new line character.
This '-d <ch>' behaviour  option to Vish read command  will not be implemented, at least not at this time.



## 2022-10-25


## PromiseFinder needs a thing to do if not found

```ruby
PromiseFinder.find [p1, p2, p3],  not_found: ->(list) { thing_to_do_when_all_promises_reject(list) }
# => result of calling the not_found: lambda
```


Reason for wontfix: There is no Promise.find, or a Subclass PromiseFinder anymore.

Currently, there is only Promise.any list_of_promises
and Promise.all list_of_promises

Both of these return a pending Promise
when that promise is run, the promises are collected with their resolution states

.any will resolve if a non-empty list  of promise.resolved? are true
   or it will be rejected? if that list empty, and all rejected promises will be in the .error result.

.all expects all promises to be .resolved? are true
   or it will be rejected? with .error being any that are .rejected? are true.


VerbFinder.find, find_all  uses Promise.any()

The builtin type, with or without the '-a' flag,
uses VerbFinder with .find, or .find_all when '-a' flag is present.
2022-09-27


## Make sure shift with no args still works ok. Like bash's shift

shift works differently than Bash shift. Requires 1 or more arguments
which must be variables to recv arguments from internal function's :_ args rest of array





## 2022-09-23

- date : Maybe an alias to sh Date

Fix: Is a alias, in my own personal ~/.vishrc




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
