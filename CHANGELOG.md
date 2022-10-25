# Changelog for Viper project

## 2022-10-25


Added 'type -a <name>' option

The type -a options will find all matching names in the search hierarchy

```
type cat
Command /v/bin/cat

alias cat=bar
type -a cat
alias 'bar
command /v/bin/cat
```


## 2022-10-21

## the builtin sh command does not capture the actual exit command of  its command string

Or, it called something else?


```
sh exit 9
echo :exit_status
0
```


## alias sr does not work:

When editing a buffer, running the function run_testrb, it fails
with the sh command not found.

```bash
viper test_api.rb
<Command>save; run_testrb
Command: sh not found
```

## 2022-10-18

## Suddenly, type of a cmdlet returns Unknown

```
range 1 6
1 2 3 4 5 6
type range
unknown
```

This started when the last commit removed CommandLet < BaseCommand





Fix: Added check for thing.class.ancestors.member?(CommandLet)
  * previously CommandLets were subclass of BaseCommand. No longer.
Fix: properly handle type false:

```
type false
/v/bin/false
```



## require inside Vish with syntax error exits with no message and 0 exit code

````ruby
# bad.rb: This will not pass syntax check
}
```

```
require bad.rb
<bash prompt
```



## require does not work with relative paths

```
require etc/cmdlets.rb
<bash prompt>
```

This works

```
require ":{vhome}/etc/cmdlets.rb"
... file is loaded
```

Fix: Added Hal.realpath to args[0] to make full path
Fix: Added rescue blocks for SyntaxError and all other possible exceptions.

## 2022-10-05

## Add commnds: ord, and chr

Does their Ruby equivalents.

```
echo -n A | ord
65
ord A
65
echo -n 65 | chr
A
chr 65
A
```

## Add hex command

```
hex "a"
41
echo "a" | hex
61
```

## Using CommandLets, implement:

- range operator : Like range in Python or Ruby Range class, '..' operator
- printf : Like Bash or C equivalent








## Release 2.0.10

### 2022-10-01


- New features
- Changes/Removals/Deprecations
- Bug fixes
- Minor improvements
- Wont fixes


### New Features

- The :path variable is now used to resolve commands.
  * The :path string is a colon delimited  list of executable paths in the virtual file system
  * The next release : 2.0.11 will have new CommandLet type of commands which exist in different parts of the :path string paths.
  * The :path variable is similar to Bash's $PATH, but only works with Vish commands.
- New keyword: 'defn' to promote lambda or block to a named function.
- New keyword 'cond' like That in the Scheme language
  * Takes pairs of blocks, executes second block in pair if first block evals to true
  * Final pair can be 'else' keyword as catch-all block
- Tracing via the '-x' flag traces command calls with their arguments
  * Use the Bash environment VISH_LOG variable to route traces to somewhere other than stderr

### Changes/Removals/Deprecations

- The split function moved to :vhome/etc/vishrc
  * Complemented by its opposite number: The join function
  *  echo command now properly understands both :ifs and :ofs, the input field separator and the output field separator

### Bug fixes

See all dated commits herein from the  date  starting at 2022-10-01
until 2022-08-18


### Minor improvements

- type command  understands the :path variable
  * type now properly reports only builtins, and not the complete set of methods  of VirtualMachine class
- test command  has more flags for any executables, blocks or lambdas
- cat can read from either virtual or physical paths just like *nix cat
  * No need to use redirection to acchieve the same effect
- Can pass start-up flags to interactive  REPL
- Control-C, when in command mode or in Vish REPL, clears line and returns to front.
  * Reports: Control-c


### Wont fix

- shift command will work differently in Vish than in Bash
  * One or more mandatory arguments which will become local variables in the function body
- global keyword works different from Bash
  * variable must exist and be set to a value. Can use 'global var' as any following statement

See the file [wontfix.md](wontfix.md)


2022-10-01



### Fixes


## Implement the 'defn' keyword

This must be in lib/runtime/virtual_machine.rb.

See the viper.wiki: PromotingLambdas.md file for a usage description.

```
defn foo { echo I am foo }
foo
I am foo

defn bar &(arg) { echo You said :arg }
bar Hello
You said Hello
```





2022-09-27


# # Complete all shift tests, esp. re: lambdas and functions




vshtest/test_function.vsh contains most tests for shift command
shift only works with non-empty args which must be all variable names that will become results of left-most shift of :_ inside functions, lambdas or stored lambdas


## 2022-09-24

## The 'type' command has explict '/v/bin/' workings

```
type cat
/v/bin/cat
```

Now that :path is in effect, must Command.resolve to get actual /v/*/<cmd>



2022-09-22

Changes to Vish REPL

And also control plus u to delete the contents of the buffer



## 2022-09-21

## Add the ability to /v/bin/test to check for a code block 'test -b { nop} => true'

Note: Can currently check if it is an executable

```
cd /v/modes/viper
test -x ctrl_a; echo :exit_status
true

test -b ctrl_a; echo :exit_status
false
```






This was fixed by getting the VFS node from the first argument to test
and checking if  it is a Block (-b) or a Lambda (-l) as well as normal checks

tests were added to vshtest/test_test.vsh
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




## Release 2.0.9
###  2022-08-18

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


