# Changelog for Viper project

## 2022-09-20

## doing a 'type of variable with true or false values

vish >declare   -p b
b=false
vish >type b
caught exception : undefined method `empty?' for false:FalseClass elsif !frames[args[0].to_sym].empty? ^^^^^^^
vish >
vish >type b
caught exception : undefined method `empty?' for false:FalseClass elsif !frames[args[0].to_sym].empty? ^^^^^^^
vish >type a
caught exception : undefined method `empty?' for nil:NilClass elsif !frames[args[0].to_sym].empty? ^^^^^^^
NoMethodError
private method `print' called for "":String


```






- shift+home, shift+end gave key not bound error when at end of buffer or start of buffer
Fixed by new functions: start_of_line, end_of_line and safe_at

- ctrl_a also gives error

Fixed by new functions: 
- select_all_buf :_buf 
- buffer_empty :_buf

- ctrl_j  : key ctrl_j  is not bound
Fixed by adding safe_at to binding in view


## Tracing is incomplete

Since only $vm.call is being traced, missing things like when keys cause actions
to be executed. 
So, only the ./scripts/001 .. 0999_*.vsh 

Should probably extend the Command class


- Command needs to  enable tracing
- But probably do not trace every printable key insert
  * But, for now, go ahead and trace everything


Fix:

New version of bin/debugging_support.rb which gets required with -x  flag to viper.
Tracing occurs at the Statement level. By defaults get written to stderr.
Using the VISH_TRACEFILE=<file.log> env variable, redirect tracing output to <file.log>

Note: There are very many long lines
Each statement is preceeded by '>> ' and succeeded by '<< ' duplicating the same content.
When investigating problems, maybe egrep for onely lines starting with '^>> '

Another hint: pipe this egrep output into 'cut -c 1-80' to cut back on overmuch trailing content.



## 2022-09-13

- Ctrl-o at the end of the buffer does not work


Fixed by adding functions:

- open_line_below
- open_line_above : bound to meta_o

Added help for these in ./doc/keys/viper.json



## 2022-09-10

# Major Bug

## in latest, Viper macros fail to work

1. viper foo.rb
2 'def'
3. meta_comma
  * Should expand to def method with cursor at start of method

Get:


defCommand: shift:: not found: 6

Problem is in function play_macro in scripts/010_macros.vsh

we used :ifs to split the atom from the line of cat </v/macros/.rb/def
This atom might be:

- key_i
- meta_r,15

the 15 above is the data

ifs="," shift key no longer works

Correction made to scripts/010_macros.vsh: play_macro

The proper way to split a string is with the split function. The output can be piped to to the read function:

In play_macro, the required variables are key, data and _sup
(where _sup is supplemental)
Note: both data and _sup can be empty

```
split :atom "," | read key data _sup
```

replaces several brittle lines of code

3. 


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


