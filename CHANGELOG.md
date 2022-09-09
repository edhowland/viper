# Changelog for Viper project

## 2022-09-09


### cat should be able to read all files on command line just like star nix cat can

```
echo hello > h.txt
cat h.txt
hello
echo hello | cat foo bar - baz
foo
bar
hello
baz
```

## 2022-09-07

Added the ability to call Vish REPL: ivsh with other Viper arguments:

```bash
$ ivsh -e 'a=2'
vish> echo :a
2
^D
$ ivsh -s file.vsh
vish> type myfunc
function
```

## 2022-09-06

### Added cond expression

```
cond { true } { echo this clause should fire } { false } echo this clause should not fire }
 => this clause should fire
cond { false } { echo not fired } else { echo will fire }
# => will fire
```


Note: the keyword 'if' is aliased to 'cond

```
if { true } { echo ok } else { echo not ok }
# => ok
```


## 2022-09-02

Added "-d" to /v/bin/test

Now returns true if path is a directory


Fixed both functions and lambdas to properly handle rest of args like :_ to work more like Bash

```bash
function foo() {
  a=$1; shift; b=$1; shift
  echo $@
}
foo a b c d
# => c d
```

```
function foo(a, b) {
  echo :_
}
foo a b c d
# => c d
```



## 2022-08-18

Release 2.0.9

Candidate release: Indy 2.1 pre-release candidate #1

## 2022-08-15

Release 2.0.3

- Added require 'set' to lib/viper.rb : Fixes problem w/Ruby 3.1+

All tests now pass
Somehow lib/api/character_traits.rb:12       @traits || @traits = ::Set.new
The Set constant could not be found or  w/o the ::Set, assumed
CharacterTraits::Set. Unclear what changed from Ruby 3.0 to 3.1


## 2022-08-10

Release 2.0.2

- Added defensive coding to VirtualMachine.mount. Args must have length > 0
  * Added VirtualMachine::IOError
- Updated Gemfile to make kpeg explicit to version 1.1.0.
  * Newer versions use 1.3.x which is imcompatible with Vish parser



## 2022-08-09

### Release 2.0.1

Fixed compat w/Ruby 3.0.0: Ranges are now frozen and cannot be extended.
hence: A test in test/blank_test.rb cannot be run

- After markdown parsing was removed: removed test in test/hunt_test.rb


