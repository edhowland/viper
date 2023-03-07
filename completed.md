# completed bugs

## 2023-03-06

## cd sometimes get caught and cannot escape from a VFS dir

```
cd /v
mkdir tmp
cd tmp
cd
rem should return to starting point
pwd
/v/tmp
```

This is a HeisenBug, cannot replicate it






Fix: No real bug here. Reason it seemed to be a HeisenBug was because of
that MacOS sometimes will repeat a previous line instead of the current actual line
To check this: Use line mode in QuickNav on mode and press up arrow


### Actual bug here: Cannot cd . in any VFS path

Fix: checked for this in various VirtualLayer.rb and vfs_root.rb code.

## Add new Rake task: release

Use a here document to list all the steps for creating a new release






## 2023-03-04

## charm problems



## charm config project has a incorrect suggestion

It refers to the old charm ignore instead of charm config ignore



### charm status has some wrong help messages


Fix: Created new status module: statlist
This individualizes the many separate charm status checks
They can now be reordered, or added to at well.

## 2023-03-03

## After initial git clone of viper, welcome banner does not display





Problem was that .gitignore had full path to ./local/etc/no-display-welcome-banner

## 2.0.13.a does not work out of the box

Check out the code on dell:dev/previous_vipers/2.0.13.a/viper and ./bin/viper Or setting the path first

Fix: Defensive coding in local/vish/prelude/009_package.vsh:
Only add :lpath components from :chome/packages, :chome/plugis unless they actually exist


## 2023-03-02
## Added PS2 -like dynamic prompt to reline stuff *

This works with both :prompt and :prompt2
Needed to add a Reline.prompt_proc = ->(b) { [fs[:prompt], fs[:prompt2]] } or some such code.
See bin/libvish.rb



## head, tail should be able to read from first argument instead of just stdin

Also should be able to take number of lines to read

## 2023-03-01

## when cat is given a file path it cannot find, its dies


Fix: New fns: extract and filter_args which splits argument list into a
duo of an ok_list and a bad_list



## capture command the first block does not seem to execute in the current scope

```
rem capture.vsh utests whether the execute bloc within capture command can change global env
capture { aa=foo } { exit }
type  aa
```

```bash
vish capture.vsh
aa Unknown
```





2023-02-28

## Setting values in  .vishrc like :prompt have no effect if set other where in ./local



## Make pry debugging to rely on ./bin/libvish.rb

Now does this manually in ./pry/*.rb

Rationale: Pry should do whatever Vish, Viper and ivsh all do naturally

Old assumptions: Old pry used to rely on the pre-2.0.12 file structure
New vish now loads everything from the ./local/vish/... E.g. bin/boot.vsh and etc/vishrc and prelude module



## Make sure that MPATH and LPATH can take relative pathanems

```bash
MPATH=.. charm module ls
```


Note: These to new file local/vish/prelude/004_environment.vsh

## echo -n does not work at all



## Problems with new ivsh: E.g. the pure vish script version

### Cannot pass arguments to ivsh like -e and -s

Because of Bash shell script: ./bi/ivsh and the call to vish





Fix: Reverted to ivsh Ruby script.
Added explicit \n before each iteration of loop
This recovers the state of the terminal line buffer before Reline
gets ahold of it. Now the old option parsing is back in place.
ivsh Bash shell script and the vish_repl.vsh are now  in ./examples/repl
Nice try but no bananas


### Still echo -n foo has no output in ivsh




Fix: Problem is that the Reline library does a clear line before outputing the prompt, this happens
in raw mode. Solution was, although not perfect, was to output a newline before
calling safe_get_line in bin/libvish.rb


## 2023-02-27
### No matter what I do, the prompt is just 'vish' and not whatever the :prompt variable is

Note: when changing the prompt to have a '>' or '>>' after it
it it chompts that off



Fix: Only uses :prompt inside the getline CommandLet
If it is passed   as the first argument, then chompts off the  everything from the first space to the end of line/statement

This is a wont fix

### Entering a blank line immediately exits




### When the vsh_parse blk happens, it gets lost when exec'ed

1. Start ivsh # The vish version, not the ivsh.rb version
2. try: 'echo -n kak | read abc'
3 The abc var is unknown

But:

```
vish> echo -n hello world | read abc; global abc
vish> type abc
Variable
hello world
```

This is because the whole thing is happening inside the rep1 function, methinks



## 2023-02-19

## Get an ls error when invoking charm package ls


```bash
$ charm package ls

```






## store command fails with bad error method when target directory does not exist

```
store &() { nop } /v/nada/foo

undefined method `[]=' for nil:NilClass

    my_node[elements[-1]] = object
           ^^^^^^^^^^^^^^^^
```

This should be a better error message. Test the existance of the target dir first.

## Change ~/.vishrc to become ./config/vish/vish/rc
If ~/.vishrc still exists it is loaded for backward compat.

## LPATH, MPATH should be able to change the package and module search paths for all programs not just charm *

Both are defined in local/vish/prelude/007_variables.vsh



2023-02-11

## The order of loading the various ~/.vishrc or ./.vishrc is not correct

The prelude code overrides them




## Add -c option to ./vish.rb

This should be some value option to check the syntax  of a source file and exit




## 2023-01-21


## -s, -e should remove themselves from argc and argv

Once all of these -s and -e args have been processed, then :argc should  reflect the emaining args count
This does happen with :argv



## vish /full/path/to/file.vsh will not work

It seems to prepend the current dir before this value:


```bash
vish /home/edh/tmp/viper/e.vsh

/home/edh/foo//home/edh/tmp/viper/e.vsh:0: exception No such file or directory @ rb_sysopen - /home/edh/foo//home/edh/tmp/viper/e.vsh
thor   foo  

```


## The -s, -e options to vish executable occur after the source file has been sourced

This is because they get opened inside of local/vish/modules/init/002_process_sources.vsh

Change to a function that gets called inside the when_load init { ...; process_sources }
And this will fix the previous bug about prepending the current path to the source

Remember to test all of vshtest/all_tests.vsh and single vshtest/test_something.vsh as well.



## 2023-01-20


- implemented the ./local/etc/no-viper-welcome-banner  which is git ignored.


## 2023-01-18

## import on empty directory fails

This is because the ls command will report its glob passed to it

???_*.vsh : No such file or diractory



Fix: with ls :exit_status repaired added suppress { ls ???_*.vsh} && to before for s in ???_*.vsh { ... } in local/vish/prelude/002_import.vsh
## HeisenBug: sometimes vshtests/all_tests.vsh fails

```bash
rake
...

test_mkdir_1 : expected block or function to return true but returned false instead /v/dir/foo not created
rake aborted!

```

Running it again usually works






Fix: changed to mkdir /v/dir/foo_1. Sometimes conflicted with /v/dir/foo


## in testing: vunit.vsh function assert is not robust

E.g. try to run some command then tests its :exit_status, Ruby barfs error message

```bash
ivsh -s vunit.vsh
true
assert :exit_status

/home/edh/tmp/viper/lib/runtime/command.rb:40:in `resolve': undefined method `empty?' for true:TrueClass (NoMethodError)

      return Null.new if id.nil? || id.empty?
                                      ^^^^^^^
  from /home/edh/tmp/viper/lib/ast/statement.rb:118:in `block in execute'
  from /home/edh/tmp/viper/lib/ast/statement.rb:97:in `bump_frames'
  from /home/edh/tmp/viper/lib/ast/statement.rb:114:in `execute'
  from /home/edh/tmp/viper/lib/ast/statement.rb:139:in `_call'
  from /home/edh/tmp/viper/lib/ast/block.rb:23:in `block in call'


```


Note: This bug is when a non-string is placed in the command position of a command

```
true; :exit_status

... same error
```



Fix: added cmdlet s is_true, is_false to go with assert_true and assert_false in local/vish/prelude/010_cmdlets.vsh

Repaired many inconsistant asserts in vshtest/test_*.vsh

Note: assert_true is alias for assert

assert is functionwrapper over is_true
assert_false is function wrapper over is_false

## ls exit_status is neither true or false

It exists but seems to be an empty string

In Bash, if even one file is missing in args, ls returns 2 exit code



Fix: Added proper exit_status to lib/bin/ls.rb 


## 2023-01-09


## The -i option for ./viper.rb should return to the top of the file

Currently, it places the cursor at the end of the file


Fix: Added beg :_buf to end of fn process_i





 ## scratch alias has failed to work now

```bash
./bin/viper -e scratch
```

First buffer is Unnamed1
second buffer is scratch1

Fix: In open_vip_files fn, added conditional not test -z :_buf which then does a nop
This then just ignores any buffers that might have been created before post processing of 
open the files on the command line. The scratch fn does just that






## 2023-01-05

## There are several local/viper/modules/*/00?_*.vsh that are empty

Remove these and renumber



### Also in local/viper/modules/edit as well



## Renamed local/viper/modules/edit/0??_*.vsh to be numbered correctly


## Fix up the local/packages/viper_pkg.vsh and function viper.

should not have a meta vip inside it


Fix: Removed meta before vip at end of viper function.
Also removed the apply fn_2, as it is redundant

## Moved ./scripts/ , ./etc/ , ./ext/ to deprecated/2.0.12.c/

Ran all tests and found magic file path in minitest/test_glob.rb. Changed etc to local to fix

Added function sethelpbanner to set the possible -h help banner.
Can be called multiple times to have additonal lines.

Is recognized by process_h function by looking in:

/v/options/:{mod}/help/banner




## 2023-01-01

## Changed search via ctrl_f, ctrl_r and ctrl_g to use getline search instead

Made 2 new functions in local/viper/modules/edit/005_search.vsh:

1. do_search {fwd,back}
2. search_again



## Made the -i option work for vip2_pkg.vsh or the vip package that it aspires to be

Changed the arguments to lib/bufnode/openf.rb the fast open

Note: This can also read from standardin to add to an existing buffer.
But: it will overwrite the end of the buffer after the cursor position.
Probably only approiate for new empty buffers at this time.

## If in Viper and either Command or in Vish, type exit. get bad error message:

```

vish >exit
VirtualMachine::ExitCalled
exitting Vish
```

## 2022-12-31

## Added -i (partially) to ./run-pkg.rb and vip2_pkg.vsh to create the
a new bufer 'standard_in' that has the .no_ask2_save stored in its metadata

TODO: get it to read from stdin


## created process_s for all current packages: repl (./ivsh.rb), vish and vip2




Remade vip package to only import modules of functions and leave processing
to the when_load vip2 { ... } event.




## 2022-12-29

## Make the :shell variable use the full path.

TODO: Must create a ne file in local/vish/prelude/0??_*.vsh for cmdlets
and mv the rb_scriptname command there



## Added -c syntax checking to ./vish.rb

Consists of new file local/vish/modules/option_processing/002_process_c.vsh and
corresponding process_c function. Will exit the program after processing
all of :argv.



## 2022-12-28


Moved fns {set,run}_ext_fn to local/vish/prelude/005_functions.vsh

This makes 'load vish_lang' available to both ./ivsh.rb and ./vissh.rb

TODO: Must add -c option to ./vish.rb


The checkvsh fn was changed to call new fn: check_vish_syntax
This new function can check both :_buf (as before) and also any *.vsh in the filesystem.

## 2022-12-27

## MAJOR: add back in extension/file type checking

If in ./viper.rb foo.rb

```
Command: check
No syntax check for this file type
```


Also, this does not work

```
Command> checkrb
checkrb not found
```



Fix: See below

## Re-established the macro facility for vish_lang plugin

## re-established ruby language plugin
Now works like its 2.0.11 cousin.






##  Hooks for language plugin support

functions for set_ext_fn and run_ext_fn for extension file types.
Pass a lambda to set_ext_fn vsh &() { global_var=foo; global global_var }

Added when_load viper { load vish_lang } to viper package


## 2022-12-26


## Created package_path to search :lpath for first matchping package.

This is used in fn load package

In preparation for local/plugins being added to :lpath

## 2022-12-24


## Problems with rm command:
### Also problem if no file exists and rm it, throughs exception

```
rm /v/xxx

Exception thrown
```


Fix: Gathered existant tuples of existance and pathnames, error message on non-existant pathnames
Then does the remove command on remaining existant pathnames

Returns false if no files were removed.




## 2022-12-23


Fixed test errors caused by enforcing at least a QuotedString as input to:

1. Glob.new
2. @vm.fs.aliases['al']  = QuotedString.new('baz')

### Removed All instances of StubDummy from minitest/test_glob.rb

## 2022-12-22

## source command should be able to work on files in VFS

```
source /v/options/viper/actual/e/1
```

Gets Ruby exception


Probably add this functionality to Hal

- Hal.read(path/to/file.txt)
Hal.write, .open with both 'w', and 'a' options




Fix: Changed lib/runtime/virtual_machine.rb tin def source, to fh=Hal.open(args[0], 'r')
and then fh.read from there.


## In test -e and give a dereferenced variable, can get an Undefined method error

```
test -e :argv

undefined method `empty?' for nil:NilClass

        result = node.empty?
                     ^^^^^^^
```


### This also happens for an non-existant directory



Fix: was error checking for no args and node.nil? in options[:e] portion
of lib/bin/test.rb

## 2022-12-21


## The at_exit in ./viper.rb does not ask to save any unsaved files


Fix: Made the same change in ./viper.rb as in ./ivsh.rb in rescue VirtualMachine::ExitCalled

comment out the actual exit call there.


## After ./viper stand-alone, and edit of buffer unnamed1, does not ask to save when exiting

Note: seems to be in local/viper/modules/run dir.
Is this a problem with load or import?
Seems to be a problem with parseopts.

Fix: Temp: did a cd :proj just before call to open_argv


## 2022-12-20

## Vish when loaded should have a prelude

- standard Vish and Os environment variables
  * like HOME, XDG_ star, if needed
  * :vhome, :vroot, etc.
- a sort of standard library, composed of more than things in /v/bin/ commands
- access to ARGV, ARGC, even ARGF
  * would allow for command flag processing within Vish
  * Should work for Vish scripts
- A way to process flags and command line arguments
  * Should work for Vish scripts as well
  * Should work for Vish functions

The latter might be a sort of getopt like function in Bash, Ruby, Python and others.


Change: Moved all to :lhome/vish/prelude/0??_*.vsh


## The source command sets functions, but not variables.

Note: This has been partially fixed

There set local to the script itself. You can fix this deficiency by making them global:

```
rem this is vars.vsh
foo=foo bar=bar;global foo bar
```

Somewhere else:

```
source vars.vsh
echo :foo :bar
foo bar
```


This should work like Bash.

Expect the fix is to do a fs.merge after the source has finished.



### If you call source within a function, it sets functions but not global variables

```bash
echo "var1=foo" > var1.vsh
foo() {
  source var1.vsh
}
foo
echo $var1
foo
```


Note: the variables declared in the source file are set within the body of the function itself.


Fix: Fixed in the source command itself


### Move all commands like store, push, pop from /v/bin to /v/vfs/bin

Reason: To unclutter /v/bin and make it more like :vhome/lib/*.rb of requires

Add all these to :path at startup



Fix: was in some previous commit

## Create new construct: cmdlet or CommandLet

command lets are short snippets  or strings containing Ruby code

They, once loaded, become like commands stored in /v/bin

```
vish>  cmdlet print_11 '{ puts 11 }' /v/cmdlet/misc
type print_11
/v/cmdlet/misc/print_11
vish> print_11
11
```


Command lets are first class Vish objects like functions, aliases and /v/bin commands

```
type foo
command let
declare -c foo
 loadcmd foo '{|*args, ios, fs| ios[:out].puts "foo" }'
```

Command lets can take optional flags:

```
cmdlet bar ' ...some ruby code...' 
```

### The above should default to /v/cmdlet/misc


## Add flag parsing to cmdlets

```
cmdlet foo -f 'j,k,l:' '{ out.puts(opt[:l]) }'
foo -l top.log
top.log
```

The -f flag takes a comma delmited string of options in the C getopt type.

- single char : If present, then opt[:o] return true, false if absent
- char with trailing ':', if present, returns the value passed , or an empty string otherwise

```
cmdlet bar -f "t" '{ out.puts("You gave me the -t flag") if opt[:t] }'
bar -t
You gave me the -t flag
```


Fix: Also in some previous release: See CHANGELOG.md



##2022-12-18

### Created new vish module : keymaps

This (will) set the correct :termfile which is a JSON file, and load_termfile :termfile

### Created new paqckage: local/packages/viper_pkg.vsh

This imports the correct termfile and imports viper/modules/init

You can o filename.ext and then  'meta vip' to get started.



This completes:

## Move ./etc/keymaps ... .json to local/etc

Create a way to load these when viper package is loaded


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

