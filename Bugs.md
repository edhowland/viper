# Viper and Vish Bugs

# Todo list


## Make massive fixes to README.md. Many things ther are now deprecated or removed.

## read command should work more like its Bash cousin

E.g. should be able to run a loop over it and break when EOF is reached

```
loop { read line || break }
```

## for loop cannot be given a constructed path with deref expansions in string, either bare nor dquoted

### This problem is actual a problem with the deref + glob expansions

```
mkdir /v/tmp/foo/bar
touch /v/tmp/foo/bar/1
touch /v/tmp/foo/bar/2
touch /v/tmp/foo/bar/3
touch /v/tmp/foo/bar/4
for i in /v/tmp/foo/bar/* { echo :i }
/v/tmp/foo/bar/1
/v/tmp/foo/bar/2
/v/tmp/foo/bar/3
/v/tmp/foo/bar/4

```


Now try the same for loop with a constructed  path:

```
vish >for i in "/v/tmp/foo/:{m}/*" { echo :i }
/v/tmp/foo/bar/*
```

But try this in Bash:

```bash

thor   viper  m=bar
thor   viper  for i in "./tmp/foo/${m}/*"
> do
> echo $i
> done
./tmp/foo/bar/1 ./tmp/foo/bar/2 ./tmp/foo/bar/3 ./tmp/foo/bar/4
```



## Move option processing form vish/modules/init to packages/vish_pkg.vsh: local/packages/vish.d/modules/option_handler/

This just cleans up the location of functionality from modules to packages
which are  now the main entry point for Vish apps.

## Renumber local/vish/prelude/0??_*.vsh source filenames

local/vish/prelude/001_argparse.vsh
local/vish/prelude/002_import.vsh
local/vish/prelude/003_options.vsh
local/vish/prelude/004_load_vishrc.vsh
local/vish/prelude/005_functions.vsh
local/vish/prelude/006_aliases.vsh
local/vish/prelude/007_variables.vsh
local/vish/prelude/008_events.vsh
local/vish/prelude/009_package.vsh


Move  007_variables between  005_functions and 006_aliases

This reflects the hierarchy order of both Vish and Bash 

Note: This move has no real effect.
Insert new local/vish/prelude/005_vfs_locations.vsh and move others one slot

After this is done: move the mkdir /v/known_extensions/default from new 006_functions.vsh to 005_vfs_defaults.vsh


Find other mkdir targets to move there.


## ls command has no way to spy on dotfiles

```bash
ls -a .vishrc
.vishrc
```


```
ls .vishrc
.vishrc
cd /v
mkdir tmp
cd tmp
touch .foo .bar
ls

test -X .foo;es
true
```

Problem only occurs in VFS, or so it appears



## Vish has a range operator 'x..N'. Does this undo the need for the range commandlet?

```
r=1..:{indent}
echo :r
1 2
```




## Remove the hunt command only used in the 013_help.vsh stuff

In 2.0.13, or .15 there is extensive redesign of the help system.

## Now that the source command can take a file in the VFS, improve the -e 'echo some command here' processing.

Make an universal function that is shared between viper.rb, ivsh.rb and vish.rb


```
for s in /v/options/:{__FILE__}/actual/e/* { source :s }
```

This has been proved to work now.




If this is a function now, then move it's processing to the when_load vish { process_e_flag }
in local/packages/vish_pkg.vsh

We want the -e option in ./vish.rb to be invoked after all the other  files have been loaded.
## The ruby type of :argc is an integer, and thus will not play nicely with the eq command

Options:

1. Make the eq command more forgiving
2. Make the :argc a string

Decide on one of the above 2 options in light of Vish propensity for strings



## The unalias command should take an unlimited of alias arguments

Also, if the string is not aliased, report an error and return false

But continue to unalias the rest of the arguments

## Make Deref.call more robust. If @pattern is a string after de-laising

In lib/ast/deref.rb:12 in method call

Should check if @pattern.respond_to? :call, if not, then if respond_to? :to_s

If neither, then raise Exeception something wrong internally

If :to_s, then call it

## Added PS2 -like dynamic prompt to reline stuff


## Check out if more than one Reline can exist


Probably just call it with a different prompt

But, does it share the same history as the REPL one, if used for search?

## Add -c option to ./vish.rb

This should be some value option to check the syntax  of a source file and exit



## Come up with more functional approach to the ls command

### Abstract

The ls command  already uses the Promise api to handle all the various
situations it can encounter. However, in the l1 method, the driver method
still must write out errors to the stderr handle in Vish. It should only return
some sort of Result type instead of  just a list, and of good outputs.

#### ls:

- no args : the current contents of the :pwd
- arguments
  * found files/dirs: outputs them
    ** dirs descends one level deep and outputs files/dirs there
  * errors: outputs to stderr and does this first before any good outputs.


## Complete the option parsing to work with help strings


And make stored lambdas for things like -v, --version

```
store { echo :version ; exit } /v/options/init/expected/v
```

Then, in the parseopts stuff, 
with the actual/v, if set, call the block or lambda.


## Implement trampoline function to get around lack of tail-code optimization in Vish recursion

### Abstract

Vish does not implement TCO, so there is a danger of stack overflow if recursive functions
or mutually recursive function nest too deeply. The latter is particularily relevant
when doing with a meta mode situation.

### What to do: implement trampoline function that works with 3 thunks, taking an initial continuation thunk to start


#### The thunks:

1. pred : executed to see if should return from the tramp fn
2. continuation : The thunk that performs the deconstruction and returns these 3 thunks again
3. xthunk : The exit thunk that is called and returned from the tramp fn if the pred returns true

### Scheme code to investigate goes here.

### Usage within Viper itself.

The plan is to use VFS to  keep track of the current executing  event handler

/v/events
 .../exit : Special case that gets performed in tha at_exit Ruby case when Vish is leaving the building, like Elvis.
... /meta : The current executing meta mode: E.g. vip, com, vim, etc.

/v/events/current : The current event handler in operation.

1. pred

## Closures are not exactly equivalent to scheme closures

In scheme, you can create a getter, setter closure over some parameter passed to the construction constructer

Both share access to the same parameter/free variable.
Later, calling the setter, will change it for the getter as well.

### Scheme

```
(define get null)
(define set null)
(define (foo arg)
  (set! get (lambda () arg))
  (set! set (lambda (val) (set! arg val)))
)
(foo 9)
(set 9)
(get)
9
(set 10)
(get)
10
```



### The Vish problem

```
function foo(arg) {
  store &()   echo :arg } /v/foo/get
store &(val) { arg=val } /v/foo/set
}

foo 19
exec /v/foo/get
19
exec /v/foo/set 20
exec /v/foo/get
19
```


## local/vish/prelude/005_functions.vsh while/until as functions are stacking up the :_ variables

Note, if you do a shift inside a until or while body, you are shifting the remaining arguments to the until/while function
not the outer function you wanted.

This is one reason while control structures must not be functions.

### Captured code from 0??_functions.vsh

```
function while(predicate, body) {
  loop {
    cond { not :predicate } { break }
  exec :body
  }
}
function until(predicate, body) {
  loop {
    cond { exec :predicate } { break }
    exec :body

  }
}
```

The above should be a standard command, cmdlet or future macro



## :last_exception is getting set somewhere in Vish function world

Only sometimes does it get recorded by an exception
Note it does get recorded by the raise command from inside Vish


Try this out:

1. Enter Command mode by pressing meta_semicolon
2. type: echo :last_exception    - or- using el aliaias
3. See commander

Or in vish/repl mode: see com







## The grep command needs some TLC

It only works in stdin imput mode

```
echo foo | grep foo;echo :exit_status
true
```

And of cource, the single/double quoted string parsing leaves a lot of room for imporvement.

You cannot properly put backslashes in there to escape them.


### Note: grep is used only once in scripts/011_extras.vsh:

9:ss=:(count &(c) { echo :c | grep -q scratch  } :(buf_names))



## Document the H-E double hockey stix the install_cmd command

```
rem Make the klass is the top-level
mkdir /v/local/bin
install_cmd '::Foo' /v/local/bin
path=/v/local/bin foo
```

## install command needs to default to /v/bin, but accept another arg

```
install
ls /v/bin
cd
mv
ls
rm
...
```

Alternative:

```
path=/v/local/bin
install /v/local/bin
ls /v/local/bin
cp
mv
ls
rm
...
```




## help topics

Note: some of this is mentioned elsewhere in the doc and also in Roadmap.md

### cheat:

A builtin function should be : cheat

```
function cheat(topic) {
  sh curl "cheat.sh/:{topic}"
}
```

Then mention this in the help stuff.
Mention that the user should have curl installed and how to get it.

### Man pages

A function/alias should work for :

```
man bindings
...
```

What should happen is a text pager/browser should come up

There should be a way to  list topics

like the appros command or 

```
man -k topic_search_term
...
```

###  Getting meta help or help about help



```
man man
```

... should mention all of this

man help should be aliases to man man


## Hunt down all parts where random code handle wrond number of aguments

```ruby
# retrv.rb
# in def call ...
raise VishSyntaxError
```

Should use new worked arg_error in  in BaseCommand instead

Note: This needs redesign first


## in BBaseCommand (lib/runtime/base_command.rb), change def arg_error to take new required/default arg: got:

```ruby
def arg_error expected, got: 0, env
# change error message to print what it actually got
```


## create rmdir command

From its Bash cousin


## Remove instances of $in_virtual

possibly make this a @@physical in PhysicalLayer, @@virtual in VirtualLayer class boolean variables
Set in VirtualMachine.new
and whenever something changes dir

## Make a IOS (FrameStack) a stub.

This is for use in MiniTest esp. test_virtual_machine.rb and others.

Currently, this is being done manually by def setup/teardown.
Investigate the MiniTest stub/mocking framework.



## Vish grammar problems

Note: consolidate these with parser/grammar problems elsewhere in this doc

### Regex matching on both bar strings and globs cause everything to be considered a Glob:



```peg
bare_string =  < /[\/\.\-_\?\[\]0-9A-Za-z][\/\.\-\{\}:_\?\[\]0-9A-Za-z]*/ > { StringLiteral.new(text) }
glob = < /[\/\.\-\*\?\[_0-9A-Za-z][\/\.\-\*\?\[\]\{\}:_0-9A-Za-z]*/ > { Glob.new(StringLiteral.new(text)) }
```


1. Visher.parse! 'echo a*'
2. Get Block: block.statement_list.first.context.first
  * get Glob, instead of bare string

Fix: Check for exhaustive tests of the parser
Then, remove all the /\*|\?|\[|\]/ from bare_string
All tests should pass



## Promise.chain

Chains a list of promises together.

The .then will be set to  a lambda that passes the value of the first promise
that is resolved. 


If, however, any Promise in the chain, that rejects, the .catch handler is passed and
chained to the next, and all subsequent .catch handlers of all the rest of the remaining Promises

Note: This is the actual railroad design pattern

## Monads

Promises are the first step in the design of Monads which are  an abstraction
of  this design pattern.

How do you sequence a bunch disparate function calls that might fail, or raise an exception.
Or, handle the side-effects in such a way, that the monads are still composable.



## The map, filter and reduce functions should work on stdin as well. and also each

Currently, they only work for a list of passed arguments.

```
reject &(x) { test -z :x }  :foo :bar :baz

rem should work like this:

echo :foo :bar :baz | reject &(x) { test -z :x }
```

For this to work, the read command must capture its input into the :reply variable.
See the Bug about this.


## in vshtest/vunit.vsh: the placement of assert_eq is backwards

Should match its minitest cousin

If changed, will not require any  changes to existing tests

## Candidates for conversion from BaseCommand or FlaggedCommand to CommandLet s

### Some missing *nix commands could be done as aliases:

Note: These should be preloaded and called from ./etc/vishrc during prelude load time.

- cut : "sh -c cut"

Some commands could be done better as a commandlet instead of a a ./lib/bin/cmd.rb:

- bell
- basename
- dirname
- pathmap
- realpath
- hd
  * Move this to ./cmdlet/misc/utils.vsh
- rand
  * takes the -c option.
  * write tests for this in vshtest/
- touch
- mkarray
- true
- false
- nop
- not
- eq 
- lt, lte
  * Alse make gt, gte
- sleep
- unset


### Commands to be removed

- null

This command is never used. Not sure what its purpose is?

### Commands to be renamed

- reverse : rev
  * leave as BaseCommand

### New commandlets

- mkhash
  * hget :key /v/hash/myhash
  * hput :key :val /v/hash/myhash
- reverse
  * obeys the settings of :ifs and :ofs
  * only works on  stdin.read and args[0] .. args[.last
  * Move to cmdlet/misc

Note: Not used in any Viper scripts

## Make ruby code formatter work to clean up code base




### Deprecations:

### Possible removal of describe command. Useless at this time

- rline, class Rline, Buffer.rline.
  * never called in any script




### Make ord, chr and hex also  read from either stdin or use first argument

### Partially implement, but does not properly implement capture closures, esp. inside REPL: ivsh

```
function foo(x) {
  defn bar &() { echo :x }
}
foo 99
bar

```

The last line should not be blank


But works if using the store command from inside a function





## Implement 'when' command. First part of case expression

This does not need a surrounding case statement first. 
E.dg. 'case' can be a function

when might work like

```
when :foo { echo I only execute if :foo is true }
when { test -f /v/foo } { echo I only execute if first block is true }
else { echo I only execute when all other things do not execute }
```



else may be harder to compute

Can 'when' be a Vish function?



# Bugs

## The -i option for ./viper.rb should return to the top of the file

Currently, it places the cursor at the end of the file

## Whenever you call getline prompt the screen reader does not output the prompt

This happens for meta_semicolon Command
and  for ctrl_f, ctrl_r

How does this work in 2.0.11 and previous versions?

## import on empty directory fails

This is because the ls command will report its glob passed to it

???_*.vsh : No such file or diractory


## load of one module cannot load another module

### Corrected yet?

E.g. in ./local/viper/modules/edit/098_default_plugins.vsh is load vish_lang
which does not get executed

But: there are such things like meta packages. For instance, vip actually
does load viper internally.


## Name conflict with :mapth 

mpath is used in new import fn and also in macros

Change it for macros




## ls command cannot find dotfiles in VFS

See the note in # Todo list above for examples



## There is no rm -f command.


## Copying once, then another time in the same file results in the previous contents being prepended to contents of clipboard

Note: This is not handled well via the CharacterTrait object not getting reset.
Is there another way to do marking?
Remember, the original  idea was to allow for movement of the marked pointer
around without losing iits position in the environment of inserts and deletes


## viper option parsing

### -n, --no-start breaks

Note: this is broken even in 2.0.10 and later

```bash

```

### The -R or run only and exit option really does nothing

```bash
./bin/viper -R -e nop
Command not found: nop
```




## The sh command should prevent users from passing a VFS pathname anywhere in the arguments

This includes actual binaries in /v/bin

E.g. This should not work

1. No pathnames in VFS:

```
sh /v/bin/cat foo bar | cat
```

2. No arguments in VFS:

```
sh cat /v/foo /v/bar | cat
```

...

## help system is throughly broken

In Command mode or vish/ivsh: run help:

```
help

caught exception : undefined local variable or method `parse_md' for #<Mdparse:0x00007fac952842b0 @options={}> parser = parse_md ^^^^^^^^ Did you mean? parser
NoMethodError
private method `print' called for "":String

        out.print args.join(_frames[:ofs])
           ^^^^^^
/home/edh/tmp/viper/lib/bin/echo.rb:9:in `block in initialize'
/home/edh/tmp/viper/lib/runtime/flagged_command.rb:30:in `call'
/home/edh/tmp/viper/lib/ast/statement.rb:120:in `block (2 levels) in execute'
/home/edh/tmp/viper/lib/ast/statement.rb:105:in `wrap_streams'
/home/edh/tmp/viper/lib/ast/statement.rb:119:in `block in execute'
/home/edh/tmp/viper/lib/ast/statement.rb:97:in `bump_frames'
/home/edh/tmp/viper/lib/ast/statement.rb:114:in `execute'
/home/edh/tmp/viper/lib/ast/statement.rb:139:in `_call'
/home/edh/tmp/viper/lib/ast/block.rb:23:in `block in call'
/home/edh/tmp/viper/lib/ast/block.rb:19:in `each'
/home/edh/tmp/viper/lib/ast/block.rb:19:in `call'
/home/edh/tmp/viper/lib/bin/loop.rb:9:in `block in call'
/home/edh/tmp/viper/lib/bin/loop.rb:9:in `loop'/home/edh/tmp/viper/lib/bin/loop.rb:9:in `call'/home/edh/tmp/viper/lib/ast/statement.rb:120:in `block (2 levels) in execute'/home/edh/tmp/viper/lib/ast/statement.rb:105:in `wrap_streams'/home/edh/tmp/viper/lib/ast/statement.rb:119:in `block in execute'/home/edh/tmp/viper/lib/ast/statement.rb:97:in `bump_frames'/home/edh/tmp/viper/lib/ast/statement.rb:114:in `execute'/home/edh/tmp/viper/lib/ast/statement.rb:139:in `_call'/home/edh/tmp/viper/lib/ast/block.rb:23:in `block in call'/home/edh/tmp/viper/lib/ast/block.rb:19:in `each'/home/edh/tmp/viper/lib/ast/block.rb:19:in `call'/home/edh/tmp/viper/lib/ast/function.rb:27:in `call'/home/edh/tmp/viper/lib/ast/statement.rb:120:in `block (2 levels) in execute'/home/edh/tmp/viper/lib/ast/statement.rb:105:in `wrap_streams'/home/edh/tmp/viper/lib/ast/statement.rb:119:in `block in execute'/home/edh/tmp/viper/lib/ast/statement.rb:97:in `bump_frames'/home/edh/tmp/viper/lib/ast/statement.rb:114:in `execute'/home/edh/tmp/viper/lib/ast/statement.rb:139:in `_call'/home/edh/tmp/viper/lib/ast/block.rb:23:in `block in call'/home/edh/tmp/viper/lib/ast/block.rb:19:in `each'/home/edh/tmp/viper/lib/ast/block.rb:19:in `call'/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:75:in `block in call'/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:396:in `_hook'/home/edh/tmp/viper/lib/runtime/virtual_machine.rb:75:in `call'/home/edh/tmp/viper/bin/viper:251:in `block in <main>'/home/edh/tmp/viper/bin/viper:251:in `each'/home/edh/tmp/viper/bin/viper:251:in `<main>'thor   viper  
```

Note: This help system relies on parsing Markdown and reads markdown files from the :vhome/doc folder. Not sure how this is supposed to work





## HeisenBug: sometimes vshtests/all_tests.vsh fails

```bash
rake
...

test_mkdir_1 : expected block or function to return true but returned false instead /v/dir/foo not created
rake aborted!

```

Running it again usually works





## the test -f does not behave exactly as does the Bash cousin

```bash
mkdir foo; touch bar
test -f foo;echo $?
1
test -f bar;echo $?
0
```


```
mkdir foo; touch bar
test -f foo;echo :exit_status
true
test -f bar;echo :exit_status
true
```





### The existing behaviour becomes -X, and -f becomes what -X does now

Note: a lot of code relies (.vsh code) on the current existing behaviour of -f working as it does now



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





## reverse is confusing




```
reverse 1 2 3 4
4 3 2 1
for i in :(range 1 4) { echo :i >> l.out }
reverse <l.out
4 3 2 1
```

This is very confusing. Second example works ok like Bash/ *nix 'rev'
Change its name to 'rev' then.

See reverse in # Todo list








## The rm command has no  way to remove files recursively

```
rem this does not work:
mkdir aa1/bb2/cc3
rm -rf aa1
Caught exception
```


For physical files you can do the following, and that can be aliased

```
sh rm -rf aa1
alias rmrf='sh rm -rf'
```




## wc commands does not work like its Bash cousin

```
echo hello world | wc -w
```





## Oustanding end of buffer bugs

Note: intentionally blank in case more of these are found


ttom of bufferCommand: BufferExceeded: not found: 6



## When autoindent is on, and first yank then paste , indent gets doubled

1. goto line that is indented
2. yank that
line
3. open new line
4. paste

  this line is indented
    this line is indented

indenting above is doubled


## Vish parser problems


### String interpolation should handle escaped chars

```
echo "hello\nworld"
hello
world
```

This just repeats:

hello\nworld


### Parser stops on empty lines. Nothing is processed after a blank line

```
rem a commemt

function foo() { nop }
rem The above and the rest of the file is skipped
```



#### An empty line does not parse at all

This might be what is happending above:

```ruby
Visher.parse! ''
Exception: VishSyntaxError
```
### bare string interpolation does not work

```
echo :vhome
/home/{USER]/viper/
echo :{vhome}

echo :{vhome}/lib

```

This works in double quoted strings.
This causes a problem for globbing with a variable substitution

Can be handled with a  bad hack:

```
mytmp=:(echo ":{vhome}/scripts"); (cd :mytemp; for i in ???_*.vsh { source :i })
```



### The range operator does not check for syntax errors

```
r=1..:{indent}
echo :r
1 2
rem above correct, next is bad
r=1..:indent
echo :r

.. hangs
` ``

## Meta mode not quite working yet

Switching and out of temporary modes is somewhat broken

You can use eith the command mode/vish REPL to run the function meta_modes, or in viper mode: fn_9
to print out the meta modes ccurrent in effect.

Notice the following sequence:

1. start viper: fn_9: Meta modes are: vip
2. enter command modes, and run meta_modes. : vip / commander
3.  fn_9 : vip
4. command mode: vish
5. meta_modes : vip / com
6. Ctrl_d Back in  vip, fn_9: vip / com / vip


## Refactors

### When vim mode is enabled in the future

The startup sequence should be:

- no existing file or empty file
  * empty files could be files with only newlines in them
- When the '-l' flag is supplied to goto a specific number

The editor should start up in insert mode

In all other cases, the editor should start in normal mode.


### Completly remove 'on' as the entire event handlers are not functional

Also remove the Event class.

### New at_exit handlers work in ./local/vish/prelude/007_events.vsh
There is only 1 event handled: the exit event:

```
ls /v/events/exit/*
1
2
3
```

Each call to at_exit { } will add to another number in /v/events/exit/1,2,3,4 ..., N

The run_exit_procs function is called to perform all these in order upon at_exit do/ .../end in Ruby code.

- Also remove the '-l', --log from options and function logger
- The call to load_event is just a 'nop'. Ess ./etc/vishrc
  * Remove all of that


## changes to Vish prelude

### Higher order functions like map, filter .etc

These functions should eliminate the first line 'shift fn' and make it
it a parameter.

```
function filter(fn) {

...
```


The first line should be a check the the fn is in fact a function

```
function map(fn) {
  test -l :fn || raise map requires first argument to be a lambda
```


# Design flaws


## Should allow for command substitution in double qoted strings like Bash

```bash
a="$(echo 1 2)"
echo $a
# 1 2
```

```
a=":(echo 1 2)"
echo :a
# should be:  1 2
# Actual
":(echo 1 2)"
```

When string interpolation happens, not only should
brace expansion occur, command substitution should also occur.

Is this a parser failure or vish runtime backend failure?



## In support of processing. Make a switch/case or match like functionality

Right now, we can use the 'eq' command to  perform this sort of thing, but it has
no break out early on failuer like switch statements.

Note: See the discussion of the when command above
Proposal is to add another
/v/bin/case command

```
case :flag { when 1 { rem action to perform when :flag is 1 }} { when 2 { rem action to perform  :flag is 2 }} { else { rem action to  be performed when no match occurs }}
```


## The builtin 'declare -f function_name'
does not quite work properly. If the original function had a a command substitution in it like:

```
function foo(f) { b=:(basename :f); echo :b }
```

You get this:
```
declare -f foo
function foo(f) { b=:({ basename :f });echo :b }
```

Notice the extra '{', '}' enclosing braces inside the ':(basename :f)'

This occurs because every time there is a Block, it gets written like:

```ruby
'{' + Block.to_s + '}'
```

Work needs to be done here to understand this better.
This, also does parse correctly, but will not load properly at runtime.

### Parameter names are not working in 'declare -f fn_name'
 Where inside, there is an lambda function with a parameter
```
function bar() { count &([:f]) { { echo :f } ) }
```

Notice the '[f]' inside the '&([f]) { ...'

Another similar problem to  the above. *args is getting .inspect as a Ruby array.



## Bad code smell: lib/bin/capture.rb

There are 3 code blocks passed to capture in *args:
These are named prosecute, sentence and trial
BAD names: Rename to try_block, exception_block and final_block 

# Implement relative require for Vish 'require' command

source ./lib/bin/require.rb




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



## MiniTest : links

### Getting started with MiniTest

https://semaphoreci.com/community/tutorials/getting-started-with-minitest

### Mocks and Stubs with MiniTest

https://semaphoreci.com/community/tutorials/mocking-in-ruby-with-minitest




Note: At the present time (2.0.12), no need for StubDummy. See wontfix.md: 2022-12-23
