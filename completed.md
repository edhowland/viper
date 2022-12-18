# completed bugs

##2022-12-18


### Made load package a new function

#### The app stack as it now stands

- files (file.vsh) : files that can be sourced with source file.vsh
- modules (init, edit) : libraries of .vsh files in a directory that can be  imported with import module
- packages : (viper) A collection of 0 or more modules or files that can be loaded with load package

When a module is imported, if there exists a file called: :{module}/on_load.vsh it is sourced and executed.

when a package is loaded, Vish checks if a new block or lambda has been create in /v/packages/:{package}/on_load
and if it exists and is executable, then it gets run after the load.

There exists a function: when_load that takes a package name and block or lambda
and stores it in /v/packages/:{package}/on_load. This helper function is run if needed
in the :lpath/:{module)_pkg.vsh file.

This is used to load the viper editor:

load viper

If run in the RePL, then use o to open a file and then run: meta vip

```
import viper
o file.vsh
meta vip
```

At this point, you are in the Viper editor.

## 2022-12-17


added local/viper/modules/edit/0??_*.vsh

The on_import.vsh there will load local/viper/bin/viper.vsh

This gets you many of the Buffer node commands located in /v/viper/bin

```
mpath=":{lhome}/viper/modules::{mpath}"
import edit
o file_to_open.vsh
meta vip
```

Much does not yet work


## 2022-12-16


## rem aliased get hosed after calling it within a function twice

```
cat saved.vsh
function r() {
  rem
}
r
r


undefined method `call' for "nop":String

    derefed_pattern = @pattern.call frames: frames
                              ^^^^^


```

This occurs in line 12 of lib/ast/glob.rb



This also occurs in  old ivsh as well in ./ivsh.rb

Fix: In lib/ast/alias_decorator.rb:

Glob.new(QuotedString.new(string))

Also in lib/runtime/verb_finder.rb, need to call :to_s for QuotedString, or any other thing

Note: Todo: still need to find whow calling a function twice caused this problem

## 2022-12-15

## Major Bug: ls does not seem to output to inner stdout

```bash
mkdir bla; touch bla/{t1,t2,t3}
ls bla
t1 t2 t3
./ivsh.rb
```

```
(cd bla; ls) | nop
t1
t2
t3
```







Fix: just returned stuff from inner l1 method in class Ls. And passed err to l1 for error handling.

## The on exit stuff does not work for new ./vish.rb:

```bash
cd vshtest
../vish.rb -s vunit.vsh test_eval.vsh

# back to prompt
```

But:

```bash
vish -s vunit.vsh test_eval.vsh
passed 5
failures 0
```


Fix: added lib/api/int_or_error that returns numeric value of input if 0-999, else 255



## 2022-12-13

## option parsing is not hygenic, cannot reuse variables within:

```bash
./vish.rb -e 'e=1' -e 'echo :e'
echo :e
```

need to make these dunder variables


Fix: changed local/vish/modules/init/001_process_args.vsh to construct
a single semicolon delimited string that can be passed to eval at the top level.


## Removed alias at_exit, now is function in vhome/local/vish/prelude/007_events.vsh
Will store its block or lambda in /v/events/exit/<next number in line>
Then run_exit_procs will be called by vish.rb in its at_exit do block.


## -e does not see the things set by -s, others?

```bash
./vish.rb -s lv.vsh -e 'lv'
Command lv: not found
```

Fix: in local/vish/modules/init/001_process_args.vsh:

Made sure that cd :proj occurs before and after the source module.
This is needed because, by the time 001_process_args.vsh is run :pwd is: :vhome/local/vish/modules/init
And, the source'd file itself might perform a cd itself.


## 2022-12-12

## Cannot invoke vish.rb from some other directory

```bash
cat var.vsh
echo I am var.vsh
./vish.rb var.vsh
I am var.vsh
```


Fix: was more careful regarding possible cases of 'cd contamination occurring within
the module and option processing in ./local/vish/{prelude,modules}



## Options bug: 

Value options are not truly working. They only work for simple strings
those with no embedded spaces

```
./vish.rb -e 'echo I am a string'

```

Only the echo gets evaluated above.

Needed, some type of string for a file thing in /v/options/__FILE__/actual/e/



Fix: All value options are stored in incremented numbers that are files
contained in these number files

```
cd /v/options/init/actual
ls s
s/1
s/2
s/3
```

Then you can just read, cat out, the values, or use the valoptexec function
that takes a lambda to perform with a parameter that is the content.

```
valoptexec -e &(v) { eval ":{v}" }
```

Note that the parameter passed to eval must be a single unit.


## 2022-12-09


## Super Major bug

### when starting ./vish.rb with no actual arguments get cd no such file or directory

```bash
./vish.rb

cd: No such file or directory
./vish.rb -s foo.vsh
I am foo
```



Fix: Must test if the option has actually been supplied first



## 2022-12-04

## If a Ruby integer is set into a variable, the type command does not recognize

```
rem some command that sets a global to an int
type var
Unknown
```

But can be fixed by converting it to a string with : value.to_s



## 2022-12-03

## Todo

Put ./local/vfs/bin/vfs.vsh back into ./etc/vishrc 



Completed: added that line  to loca/etc/vishrc


Added ReplPDA to def get_line in ./vish.rb
Properly, handles multi-line input
## 2022-11-29

## Remove the =begin/=end comment from lib/runtime/virtual_layer.rb: def [] path

Note: this was removed back in Release 2.0.11



## The descendants method of BinCommand::VFSCommand results in base_node_command being installed

This is because BaseNodeCommand is an actual descendant of BinCommand:VFSCommand

Possibly: filter this out


Fix: Added specific .reject to BinCommand::*.self.descendants

E.g.

- BinCommand::NixCommand rejects BaseCommand
- BinCommand::VFSCommand rejects BaseNodeCommand
- BinCommand::ViperCommand rejects BaseBufferCommand

Therefore these, via snakize,  do not get installed in:

NixCommand : /v/bin
VFSCommand : /v/vfs/bin
ViperCommand : /v/viper/bin


## 2022-11-28

### Move bufnodes, esp. BufferCommands from /v/bin to /v/editor/bin



Fix: This was done with the introduction of BinCommand::NixCommand, BinCommand::ViperCommand.

Now all commands live in /v/viper/bin and this is first in :path variable.

## Fast Open

Current:

In function fopen

scripts/001_editor.vsh:14
````
test -f :rpath && cat < :fname > :_buf && digest_sha1 -f :fname > ":{_buf}/.digest"
```

Proposed:

```ruby
class Openf < BaseBufferCommand
  def call ...
    ...
  end
end```
Use Ruby fast open and read into Buffer.b_buf directly


```
openf :_buf :fname && digest_sha1 -f ":{_buf}/.digest"
```

Above fixed in previous commit.  This Todo thing was duplicated.


## Immediate: go through all lib/bufnode/ and remove super do |*a|

replace with:

```
a = args_parse! args
```


Replace any usages of a[..] with args[..] if needed and no options are used in @options
Remove the 'end' at indent 4



## Move all functions of BaseCommand into BinCommand::NixCommand that are reasonable to do

### Start moving all lib/bin/*.rb over to inherit from BinCommand::NixCommand


##  Move all methods in BaseBufferCommand over to BinCommand::ViperCommand that are reasonable to do so

### Start inheriting lib/bufnode/*.rb that current inherit BaseBufferCommand to BinCommand::ViperCommand

#### Many of these are two (or more) levels deep:

E.g. NoArgCommand, SingleArgCommand, etc




## conversion to BinCommand::ViperCommand:

### push command, maybe pop, enq, deq etc may not work

MUST: write vshtest/test_array.vsh




Changed: Added ./local/viper/bin and in there viper.vsh

New CommandLet: viper_commands gives all class names that should go into new
:path component => /v/viper/bin

```
for i in :(viper_commands) { install_cmd :i /v/viper/bin }
```

These are all descendants of BinCommand::ViperCommand

Meanwhile, all previous commands which live in /v/bin are descendants 
of BinCommand::NixCommand.

Todo: These must be re-engineered to BinCommand::NixCommand
and lib/runtime/virtual_machine.rb:def install should only get these, not BaseCommand

## 2022-11-25


### Fixed bug in argument parsing in lib/bufnode/describe.rb:

args must have length 1 and be a virtual path


## 2022-11-19

# alt+w, ctrl+w do not work in empty buffer or at either end of buffer.

Hint: probably same problem as the "at :_buf" problem from before

Implement: Change the line in 102 of scripts/001_editor.vsh:

Should not be a is_bound with && and then ||
because the action in the then clause, if it returns false, still triggers the || action.
Could prevent it witha extra true after the apply statement, but this be ugly hack.

Change this to a cond statement.


## 2022-11-18
## Safer at command instead of safe_at function

CHANGE: this is handled in lib/bufnode/base_buffer_command.rb

There is now a rescue for the exception for BufferExceeded

BUT: Must locate the reason for getting the key is not bound when at the start/end of the buffer


Fix: added lib/api/buffer_ext.rb: module BufferExt for buffer extensions
has new method: blank_if_nil. Used in the Buffer.at method
And remove these after testing from  ./scripts/002_viper.vsh



## 2022-11-16

## ls command behaves eradically

```
test -f /v/bin/foo; echo :exit_status
false
ls /v/bin/foo

```

Note: the :exit_status should be false and an error message should be printed

```

ls: cannot access 'scripts/foo': No such file or directory
```








## cd should report its failed argument when it cannot reach a destination

```
cd /v/foo
cd: no such filer or directory
```

Should act more like bash

Fix: cd improved and relative paths and globbing fixes



## test -f with no args still gives wrong exception: No Method Error instead of of ::ArgumentError

```
test -f
caught exception : undefined method `split' for nil:NilClass elements = path.spl
```


Note: was not fixed when Hal.exist? is checked




Fix: Hal.method_missing more robust when passed a nil value

## vshtest/test_test.vsh: function _test_test_d_dot_dot ..

This test skipped because errors with Ruby error about undefined method '[]' in IOStream.

- Investigate


Fix: made /v/foo/bar into /v/t9/bar, cannot have existing foo file and mkdir /v/foo

## 2022-11-15



## Hal.exist? with no args dumps with no method error

Do more robust input sanity checks



## 2022-11-13


##

Get the folling error when running minitest_virtual_machine.rb

Not sure which test does create the exception

```ruby

_chdir: uninitialized class variable @@root in VirtualLayer

```

Fix: moved the @vm.mount in def setup of both test_virtual_machine.rb and test_sub_shell.rb to just  aftet @vm = VirtualMachine.new
and before any calls to @vm.cd


## 2022-11-09

## double astrix for ls, results in exception:

```
mkdir foo/d1/d2/d3
ls foo/**
caught exception. Wrond number of arguments, given <num>, expected 1
```








## globbing in VFS does not work with *'s

```
mkdir foo
cd foo
touch a1 b2 c3
cd ..
echo foo/*
foo/a1 foo/b2 foo/c3
rem now try vfs
cd /v
mkdir tmp
cd tmp
touch a1 b2 c3
cd ..
echo tmp/*
tmp/*
```

A bug in lib/ast/glob.rb



## 2022-10-25

Removed VerbFinder::AliasFinder, ::FunctionFinder, ::BuiltinFinder, ::CommandFinder and ::VariableFinder
from class VerbFinder.

Replace with procs that will become Promis s

Promise.any is used to find all matchers names for the verb. E.g. 'cat', 'path', .etc

The type command uses VerbFinder.find for the first matching match in the Promise.any output
The type -a option reports all matching matches


2022-09-27

##  the split function should be  be moved and fixed

Currently resides in scripts/*extras.vsh
must be moved to etc/vishrc

To fix it:

```
function split(val, sep) { ifs=:sep echo :val }
```



FIX: fixed several commits ago

## join function should use :ofs or output field separator

```
function join(sep) {
  ofs=:sep echo :_
}
```


FIX: lib/bin/echo.rb modified to use _frames[:ofs] instead of h/c ' '


##  Change raise RuntimeError in shift.rb to be a perr message and result = false

If the object is not a kind_of Array, (or  Really responds_to?(:shift),
then do the following

```
if !object.respond_to?(:shift)
  perr "object cannot be shifted"
  result = false
else
 ....
```




## 2022-09-25

### Also check where else /v/bin is hardcoded




## type does not return false if not found

Reports Command not found instead of "Unknown"
Need to capture the result of calling resolve

Need to fix  minitest/test_virtual_machine.rb:69
change assert to get from vm.ios[:err], instead of ios[:out]
and check for "Command jjj not found"

Fix: thing from Command.resolve is the actual /v/bin/false command
def type in VirtualMachine now checks against that result

Note: This is probably a bug in Command.resolve when the  output is not found
Also, the system seems to raise CommandNotFound. But where does this get rescued?


## 2022-09-23

## Should handle control plus c in Vish REPL.

Fix: added correct binding to ctrl_c in 003_command.vsh.
clears the line and reports Control-c






## 2022-09-21

## ctrl_g stopped working with command not found error

1 Do any forward or reverse search
2. press ctrl_g
3. Get Command not found error




## 2022-09-17

### attempt to cd into array in VFS:

=====

caught exception : undefined method `parent' for ["/v/clip/7NKosC\n"]:Array until p.parent.nil? ^^^^^^^
vish >NoMethodError
undefined method `parent' for ["/v/clip/7NKosC\n"]:Array

    until p.parent.nil?
           ^^^^^^^
/home/edh/tmp/viper/lib/runtime/vfs_root.rb:17:in `pwd'
/home/edh/tmp/viper/lib/runtime/virtual_layer.rb:71:in `pwd'
/home/edh/tmp/viper/lib/runtime/hal.rb:18:in `pwd'
/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:26:in `_init'
/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:54:in `initialize'
/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:327:in `new'
/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:327:in `_clone'
/home/edh/tmp/viper/lib/ast/sub_shell.rb:33:in `call'
/home/edh/tmp/viper/lib/ast/sub_shell_expansion.rb:9:in `call'
/home/edh/tmp/viper/lib/ast/assignment.rb:13:in `call'
/home/edh/tmp/viper/lib/ast/statement.rb:78:in `block in perform_assigns'
/home/edh/tmp/viper/lib/ast/statement.rb:76:in `reject'
/home/edh/tmp/viper/lib/ast/statement.rb:76:in `perform_assigns'/home/edh/tmp/viper/lib/ast/statement.rb:90:in `prepare'/home/edh/tmp/viper/lib/ast/statement.rb:115:in `block in execute'/home/edh/tmp/viper/lib/ast/statement.rb:97:in `bump_frames'/home/edh/tmp/viper/lib/ast/statement.rb:114:in `execute'/home/edh/tmp/viper/lib/ast/statement.rb:139:in `_call'/home/edh/tmp/viper/lib/ast/block.rb:23:in `block in call'/home/edh/tmp/viper/lib/ast/block.rb:19:in `each'/home/edh/tmp/viper/lib/ast/block.rb:19:in `call'/home/edh/tmp/viper/lib/bin/loop.rb:9:in `block in call'/home/edh/tmp/viper/lib/bin/loop.rb:9:in `loop'/home/edh/tmp/viper/lib/bin/loop.rb:9:in `call'/home/edh/tmp/viper/lib/ast/statement.rb:120:in `block (2 levels) in execute'/home/edh/tmp/viper/lib/ast/statement.rb:105:in `wrap_streams'/home/edh/tmp/viper/lib/ast/statement.rb:119:in `block in execute'/home/edh/tmp/viper/lib/ast/statement.rb:97:in `bump_frames'/home/edh/tmp/viper/lib/ast/statement.rb:114:in `execute'/home/edh/tmp/viper/lib/ast/statement.rb:139:in `_call'/home/edh/tmp/viper/lib/ast/block.rb:23:in `block in call'/home/edh/tmp/viper/lib/ast/block.rb:19:in `each'/home/edh/tmp/viper/lib/ast/block.rb:19:in `call'/home/edh/tmp/viper/lib/bin/loop.rb:9:in `block in call'/home/edh/tmp/viper/lib/bin/loop.rb:9:in `loop'/home/edh/tmp/viper/lib/bin/loop.rb:9:in `call'/home/edh/tmp/viper/lib/ast/statement.rb:120:in `block (2 levels) in execute'/home/edh/tmp/viper/lib/ast/statement.rb:105:in `wrap_streams'/home/edh/tmp/viper/lib/ast/statement.rb:119:in `block in execute'/home/edh/tmp/viper/lib/ast/statement.rb:97:in `bump_frames'/home/edh/tmp/viper/lib/ast/statement.rb:114:in `execute'/home/edh/tmp/viper/lib/ast/statement.rb:139:in `_call'/home/edh/tmp/viper/lib/ast/block.rb:23:in `block in call'/home/edh/tmp/viper/lib/ast/block.rb:19:in `each'/home/edh/tmp/viper/lib/ast/block.rb:19:in `call'/home/edh/tmp/viper/lib/ast/function.rb:27:in `call'/home/edh/tmp/viper/lib/ast/statement.rb:120:in `block (2 levels) in execute'/home/edh/tmp/viper/lib/ast/statement.rb:105:in `wrap_streams'/home/edh/tmp/viper/lib/ast/statement.rb:119:in `block in execute'/home/edh/tmp/viper/lib/ast/statement.rb:97:in `bump_frames'/home/edh/tmp/viper/lib/ast/statement.rb:114:in `execute'/home/edh/tmp/viper/lib/ast/statement.rb:139:in `_call'/home/edh/tmp/viper/lib/ast/block.rb:23:in `block in call'/home/edh/tmp/viper/lib/ast/block.rb:19:in `each'/home/edh/tmp/viper/lib/ast/block.rb:19:in `call'/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:75:in `block in call'/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:348:in `_hook'/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:75:in `call'/home/edh/tmp/viper/bin/viper:251:in `block in <main>'/home/edh/tmp/viper/bin/viper:251:in `each'/home/edh/tmp/viper/bin/viper:251:in `<main>'dell dell 
====


## 2022-09-12
type now properly reports only builtins, and not the complete set of methods
that respond_to? true

## 2022-09-11

## get error message if command is not found in path

something about path




## Remove dead code from shift

