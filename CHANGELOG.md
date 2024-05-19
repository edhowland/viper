# Changelog for Viper project

## Release 2.0.13.c

2024-05-19

## Corrections


- Updated README.md to reflect that only works with Ruby 3.1.2 and not 3.2.x
- Fixed bug on MacOS where the minitest/test_hal.rb errored out with a problem in 'getcwd' internal Ruby
  * Added test double to fake out the actual filesystem when Hal tries to dispatch to PhysicalLayer
  * No more explicit tests that actually write to an actual filesystem
- Corrected indentation warnings in both lib/* and minitest/*
- Corrected unused variables in lib/ minitest/
- Corrected unreachable statements in lib/runtime/virtual_machine.rb


## Additions

- Added pry/ipl.rb
  * Can now do simple: 'pry -r ./pry/ipl.rb' and then 'vm = ipl' to get some Viper ruby code running.
  * Does not run the vish_boot stuff; do that manually or use another ./pry/*.rb scrpt
- Added ./pry/indents.nu to help examine Ruby source files for indentation warnings
  * When running 'rake test' if .rb files have warnings they will be repored first in output of rake.
  * If indentation inconsistenancies occur, you can run :

```bash
# NOTE: You must have a recent version of Nushell installed.; tested with version 0.92.x

$ ./pry/indents.nu lib/runtime/virtual_machine.rb
```

You will get a table with columns: lineno indent and token0

If you supply the indents.nu with the --range, -r option, you can narrow the context around the warning output message.


The inent column reports the number of spaces before the first token (token0) on every line.
The token0 reports the first actual non-whitespace token like 'class' or 'def' or 'if, 'end' .etc

By comparing the warning message with this table around its context, you may discover that either the previous matching syntax element
or the warned line maybe either too much indented or outdented and you can take corrective measures.


Note: If using a version of Viper you know to be working, you can:

```bash
viper -l 14 lib/runtime/virtual_machine.rb
```


... and be brought to the (possibly) offending line number in the file.

```bash
./pry/indents.nu -r 14..25 lib/runtime/virtual_machine.rb
```







## Release 2.0.13.b

2023-03-06



## Corrections

- cond now returns  the actual exit status of the matching consequent clause
- rep1, repl works with a newline character output even if no trailing newline on last command
  * Tracked to a bug in the Ruby Reline module
- cat now properly handles non-existant arguments
- charm commands and subcommands have more accurate documentation
- charm status now is a set of individual checks in the statlist module
  * New checks can be added, some can be rearranged or removed
  * charm config create handles previous installations of Viper w/o ~/.config/vish/{rc,packages,plugins}/
- cd command works in VFS better
  * test -d . works
  * cd . works ok

### Changes

- head, tail commands are now function wrappers around sh head, sh tail instead of Ruby code
- grep is now function wrapper around sh grep

Note: these commands are never or rarely used in entire code base

- prompt2 now works when in a multiline input situation. Like new irb and always pry



### Removed

- In Viper meta_v does no longer been bound to anything
  * Actually edit the :_clip to see what is in the clipboard

Note: Fill out the rest of this

## Release 2.0.13.a

2023-02-19


- New Vish program: charm
  * An ecosystem manager for Viper and Vish
  * Many commands with subcommands to help with querying and creating new Vish packages, plugins and modules
  * Populating the default ~/.config/vish directory for extending Viper and Vish
-  Many fixes and extensions to Vish's import and load commands for modules and packages
- Added new Welcome banner for Viper upon startup
  * Only displays when no files to edit when Viper invoked, like vim does
  * Chan be configured away with 'charm welcome remove' and restored again with 'charm welcome restore'
- Changed the default for initialization/customization scripts
  * Previously was in ~/.vishrc . Will still work for backward compatibility
  * If 'charm config create' has been run, expects ~/.config/vish/rc now and in the future


## Release 2.0.12

2023-01-19

- All new Vish executables installed and old Ruby wrappers deprecated
  * ./bin/viper, ./bin/vish and ./bin/ivsh
  * Still thin Ruby  wrappers 
  * All work is done in ./local/**/*.vsh
- Command mode, REPL and search modes replaced with Ruby Reline library
  * Use of Emacs/Bash-like editing keys on command line.
  * Multi-line functionality
  * Start a function  definition and continue on subsequent lines until done
- Proper handling of :argc, :argv for Vish packages and apps
- A parse options library
- viper -i now creates a standard_in buffer that does not ask to be saved
  * Good for piping into from another program
  * But can be saved if wanted
- import module functionality
- load package functionality
- There are now 4 :path elements
  * /v/bin : Vish commands that act like *nix commands
  * /v/vfs/bin : Commands like mkarray, push .etc  that only work on VFS directories and objects
  * /v/viper/bin : Commands that work on buffer nodes
  * /v/cmdlet/misc : Where CommandLets get stored
  * This latter path existed in 2.0.11

### Bug fixes

- import on emptymodule/directory  now fails gracefully
- fixes for rm, cp and mv commands with multiple arguments
- Fixed rake test that occasionally failed
- vshtest/vunit.vsh and test files cleaned up
  * assert, assert_true and assert_false work with new CommandLets: is_true and is_false
- ls command when missing filesystem object, returns correct :exit_status
- source command works on files in virtual filesystem
- source file will make all variables global even if called from a function

## Release 2.0.12.c

Beta release for Release 2.0.12

2023-01-03

### Features

- New command ./viper.rb - possible candidate replacement for ./bin/viper
- Relocation of all *.vsh scripts into a single top-level folder: ./local
- Ruby code for ./viper.rb, ./vish.rb and ./ivsh.rb is now just a launcher for Vish language.
- New concept: modules. Modules are imported.
- New concept: Packages. Packages can be loaded

### Deprecations

- Many rarely used options were removed.

#### Retained options

- '-s source.vsh' sources the file. Many '-s' options can be supplied.
- '-e "vish command[s]"' Evaluates all '-e' strings after Vish bootup, '-s source.vsh' options have been processed and before the main application gets started.
- '-c'. Only on ./vish.rb. Will syntax all source files on the  arguments.
- '-l <positive integer>' Only on ./viper.rb. Will goto the line number  of the first supplied filename loaded.
- '-i'. Only on ./viper.rb. Reads from stdin into buffer: "standard_in".
  * This buffer is the first buffer in the buffer ring upon startup.
- '-v'. On all executables. Reports the version of the of this release and immediately exits.
  * The reported version for this release is : 2.0.12.c
  * This can be displayed by 'echo :version' in any REPL or Command mode.

Note: The -h' or help options is not deprecated. This is unfinished code
and will be returned in release 2.0.12 and later.



#### Previous scripts that have been removed or replaced.

- ./viper.rb

Previous ./scripts/005_search.vsh has been replaced with :
./local/viper/modules/edit/005_search.vsh

- scripts/003_command.vsh has been completely removed.
  * This functionality has been replaced by Ruby's Reline builtin library.
  * This also is true for the search prompt method.
- scripts/012_meta.vsh
  * There is no longer any "meta modes". The main Viper run loop is just
    the function: 'vip'

### Bug fixes

### Fixed the rm command

All commands: cp, mv and rm now all check for existance and report errors
if any source is missing.



#### Mixing of Globbing and alias referencing now works properly.

There is now error type checking on trying to pass a value to a Glob that is not a member of the QuotedString class or its descendants.


#### The source command can now read from anywhere inside the VirtualFileSystem or VFS.


Also, previously, the source command did not set variables in the global context.
It did set aliases and functions. Now it does all 3.


#### The :path command now includes  vfs/bin and viper/bin.

```
echo :path
/v/viper/bin:/v/vfs/bin:/v/cmdlet/misc:/v/bin

```

... in addition to /v/bin and /v/cmdlet/misc




### The ./local/ directory structure.

```
ls -d ./local/*
local/etc
local/packages
local/plugins
local/vfs
local/viper
local/vish
```


This directory layout is somewhat inspired by both Unix's /usr/local/* and the ~/.local/*
from freedesktop.org.

Note:  The old ./etc have been redistributed to ./local/etc and other places.
The ./scripts/*.vsh have been moved to ./local/viper/modules/edit/*.vsh

The ./ext/{rb,vsh} scripts and .json macro files
have been moved to packages in ./local/plugins/ruby_lang and vish_lang


These changes make the executables: ./vish.rb and ./ivsh.rb able to load faster
because, by default, do not import the viper/modules/edit module.
You can, however, still load the 'viper' package and recover all the functionality therein.
Indeed, that is what now happens in the ./vshtest/alltests.vsh, so that Viper editor tests can still run.

These 
### Modules and packages

#### Modules

Modules are simply directories containing .vsh files that can be sourced
via a single command: import.

```
import edit
```

Note: The edit module, located in ./local/viper/modules, was the old ./scripts directory.

Modules are searched within the :mpath variable. This string contains
full pathnames delimited by a ':'.
Generally, modules should only contain definitions for variables, aliases and functions.
However, this restriction is neither enforced nor even followed in 2.0.12.c.

#####  The module filename protocol.

Any filenames ina module directory must obey the following pattern:

001_xxxx.vsh ... 099_xxxx.vsh. E.g. the regex: '???_*.vsh'
This allows for 1000 files in a module. From 000_*.vsh to 999_*.vsh

If there is a file in the directory named: 'on_import.vsh', it will be sourced
after all the other ???_*.vsh have been loaded in order.
Any Vish commands can been run from that file.
Any other files or directories in a module directory are ignored by the import command.


#### Packages

A package is simply a file that can be sourced. It too is also searched in a :lpath
variable. 

The :lpath variable contains a number of full pathnames that are delimited with a ':' character
like the :path and the :mpath variables.

Packages are loaded via the 'load' command.

##### The package filename protocol

For any package to be loaded via the 'load package_name' command, it must have the following
name convention: <package_name>_pkg.vsh. And it must also be found somewhere in the :lpath search string.


Packages, being just Vish files, can do anything they please.
Generally, a package might setup some global variables, import some packages
or run some commands. Packages can also load other packages. This is what happens
with the 'vip' package which loads the 'viper' package.
You can thing of any package  as a simple package or a meta package.

When a package is loaded, it creates a directory in the VFS in /v/packages/<package_name>
If that package directory exists and contains a Vish source file named: on_load,
that file will be exec'ed, meaning it must be a stored lambda or block.
To make this easier to  create, there is function called: when_load <package_name> { Vish commands go here }.

The on_load will be executed after the entire <package_name>_pkg.vsh has been loaded.

##### Additional directory naming conventions.

This is not enforced, but the convention is to create a directory called <package_name>.d/ in the same directory
as the <package_name>_pkg.vsh package source file.


## Release 2.0.12.b

Pre-alpha interim release for 2.0.12

2022-12-15

### Features

1. New commands: ./vish.rb and ./ivsh.rb
2. Vish loading is accomplished in Vish itself via ./local scripts
3. There is only small Ruby wrapper files: vish.rb and ivsh.rb

In upcomming 2.0.12.c release a new viper.rb scriptt will be created.


### Fixes

- ls command now properly writes to stdout and stderr
- The at_exit now works properly both for versions 2.0.11  old vish command and the new .vish.rb in 2.0.12.b
  * Use of the set_exit_code to communit the exit code in :exit_code for procescc exit code
  * See vshtest/vunit.vsh
- Simple option parser written in Vish functions
- import function to load profiles for Vish executation:
  * init: The main Vish module. Performs option parsing and consumes one .vsh script file
  * repl: The main module for ./ivsh.rb Processes options
  * [future] : viper/modules/init


See the file completed.md for more details and other fixes not mentioned herein.




## Release 2.0.12.a

Pre-alpha interim release for 2.0.12

2022-11-29


### Features

- Split out all /v/bin commands into 3 paths

```
rem this is all *nix inspired commands
ls /v/bin

rem These are commands for just the VFS parts of the Vish 
ls /v/vfs/bin

rem These are Viper buffer specific commands
ls /v/viper/bin
```

- Added the above paths to the :path variable

```
echo :path
/v/viper/bin:/v/vfs/bin:/v/cmdlet/misc:/v/bin

```



These changes were needed to decouple Vish from its Viper roots.
Given these changes, it should now be able to just launch Vish as a stand-alone executable.
In the case, the Viper will become just another Vish script.


## Release 2.0.11

2022-11-19

- New features
- Bug fixes
- Wont fixes


### New Features

- CommandLets with both the cmdlet Vish command and the cmdlet Ruby function  
  * range, printf are supplied CommandLets in virtual path : /v/cmdlet/misc
  * supplied in :{vhome}/cmdlet/misc/utils.vsh
- retrv command : opposite of store command
  * retrieves an VFS object and assigns it to the supplied variable symbol

- type -a option added to search entire possible search types
### Bug fixes

- Globbing and relative path expansion greatly improved, esp in VFS paths
- ls command now behaves more like its *nix cousins
- test command for executable content now works properly
  * -b only true if a actual block or stored block
  * -l only true for true lambdas or stored lambdas
  * -x true for any of the above and also /v/bin commands or CommandLets in the :path, like in /v/cmdlet/misc
- mkdir, rm, cp and mv commands now work like their *nix cousins
  * take multiple arguments
  * proper error checking
- read command now works more like its *nix cousin
  * reamining inputs stored in final variable supplied
  * if no variables, entire input in stored in :reply variable
- The sh command captures the exit code of the system call and properly handles stdin, stdout and stderr and routes them to Vish equivalents
  * Used, for example, in vshtest/test_glob.vsh and vshtest/glob_helper.vsh
- require now works properly, for relative paths and error checking
## 2022-11-18

The at command now gives a blank string if at the end of the buffer.
It also returns true
The need for the function safe_at is no longer needed.



## 2022-11-17

### New retrv command : opposite of /v/bin/store

```
store &() { echo foo } /v/foo
exec /v/foo
foo

retrv /v/foo foovar
type foovar
variable
defn fubar :foovar
type fubar
function

fubar
foo
```



Write test for these






## test -b when presented with a Lambda catches exception on split for path

```
l=&() { echo I am l }
exec :l
I am l
test -b :l

caught exception : undefined method `split' for &() { echo I am l }:Lambda elements = path.split('/') ^^^^^^
```

Fix: refactored code in lib/bin/test.rb for options: -b, -l and -x
to use Test.executable? and obj_or_path_executable? by passing variable klass_set: [Block, Lambda]

-b : [Block]
- l [Lambda]
-x [Block, Lambda, BaseCommand, CommandLet]

test -x works for stored blocks, lambda or binaries in /v/bin/* and /v/cmdlet/*/*




## 2022-11-15

## the rm command only takes one argument

Must args.each {|e| Hal.rm(e) }

That way, the globbing will also work.

```
rm *.txt
```

Currently, only the first file is removed.

Fix: itearates over all args in bin/rm.rb



- More robust error checking in Hardware Abstraction Layer
  * checks for arity of to be dispatched function against supplied arg count


mv, cp now works with ./file and ../things, especially inside of VFS
Also, mkdir, mv, cp all works with multiple  values.


## 2022-11-13


## test -d . only works on physical FS

```
test -f .;echo :exit_status
true
cd /v
test -d .;echo :exit_status
false
```


### But works ok on ..

```
mkdir /v/dir/foo/bar
cd /v/dir/foo/bar
test -d ..;echo :exit_status
true
```

### This also causes a problem with cp dir/file .

Even both VirtualLayer.cp src,dest use realpath and that works

```
cd /v
realpath .
/v
```






## 2022-11-09

## Globbing fixed across the board
## read command now acts like its Bash cousin
## ls works more like Bash, except it does not group dirs, instead it prints full relative pathname



## The read command does not capture left over arguments into the final variable passed

```
echo hello there world | read foo bar
echo :foo
hello
echo  :bar
there world
```

### Also, if no args given, capture the entire input into the :reply variable

```
echo hello world | read
echo :reply
```





## 2022-11-08

## Globbing fixed for virtual file system

See vshtest/test_glob.vsh, vshtest/glob_help.vsh:

checks echo type globbing against the exact results of what Bash itself reports.
This gets compared against Vish globbing on the exact same physical directory tree
in both Bash and Vish globs. It then gets tested against a mirrored directory
tree in /v/glob/tmp against :vhome/vshtest/tmp


### if ls is run on a directory, from the parent, 

Never shows contents of child folder

````
ls /v/buf


```

Note: ls hasn't been fixed, but globbing works for both physical filesystems and virtual filesystem.



## 2022-10-29


## mkdir does make all arguments into directories, only the first

```
cd /v
mkdir tmp a1 b2
rem only tmp will exist
```



Fix: iterates over  all arguments


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


