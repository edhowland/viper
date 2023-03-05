# Wont fix

## 2023-03-04



## charm config ignore has a wrong exit status

Reason. This is intentional. If used in some automation script, want to exit as a failure.

## 2023-02-28

# Viper and Vish Bugs


Reason: This is MacOS Catalina bug, not Viper/Vish bug

## The sh command does not seem to work with stdin 

It does work with our Vish internal stdout

Broken:
```
echo foo | sh grep foo
```


Working:
```
sh head -1 Bugs.md | read foo
echo :foo
```

Reason: sh - is ok way to alert programmer of vish intention.
Must document this thoroughly..




## 2023-02-27


The cmdlet getline will not accept multi-word prompts as the first argument
For now, will only use the value of :prompt

## 2023-02-19

Make an universal function that is shared between viper.rb, ivsh.rb and vish.rb



## 2023-01-19
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



Reason: There is no longer a meta mode in 2.0.12 and beyond.

To start the editor, just call the 'vip' function.

## wc commands does not work like its Bash cousin

```
echo hello world | wc -w
```








## load of one module cannot load another module

### Corrected yet?

E.g. in ./local/viper/modules/edit/098_default_plugins.vsh is load vish_lang
which does not get executed

But: there are such things like meta packages. For instance, vip actually
does load viper internally.



## 2023-01-05


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





Reason: All option parsing moved to Vish see local/vish/prelude/003_options.vsh


##  2022-12-23

### Removal of StubDummy from test code:

class StubDummy
  def self.call(*args)
    #
  end
end

Reason: This was needed to add .call interfcace to bare strings in Glob.new(o)
where o was just a Ruby string. Glob.new needs at least a QuotedString or StringLiteral.

Tests were changed to explicitly add this



These changes were removed from Roadmap.md
Versions 2.0.13 and 2.0.14 are  already accomplished in 2.0.12
2.0.15, 2.0.16 and 2.0.17 are now moved up to 2.0.13, 2.0.14 and 2.0.15

## 2.0.13

- at_exit code to perform checks.
  * Instead of relying just Ruby's at_exit code to run specified code.
- range, printf  commandlets to beable to load :vhome/scripts/{001-999}*.vsh

## 2.0.14

Argument parsing  for Vish scripts
  * flags for Viper are accomplished in here instead of Ruby in :vhome/bin/viper
- Move more testing to :vhome/vshtest fro :vhome/minitest
  * NiniTests tests  should be reserved for #1 and #2 above. Ruby core and Vish interpreter
  * Need to make Vish code more testable. (Whatever that means)


## 2022-12-20

## Logging does not work

```bash
viper -L
```

Gets:
```

/home/edh/tmp/viper/lib/runtime/frame_stack.rb:43:in `pop': stack level too deep (SystemStackError)
  from /home/edh/tmp/viper/lib/ast/lambda.rb:34:in `ensure in call'
  from /home/edh/tmp/viper/lib/ast/lambda.rb:35:in `call'
  from /home/edh/tmp/viper/lib/runtime/event.rb:42:in `on'
  from /home/edh/tmp/viper/lib/ast/block.rb:22:in `block in call'
  from /home/edh/tmp/viper/lib/ast/block.rb:19:in `each'
  from /home/edh/tmp/viper/lib/ast/block.rb:19:in `call'
  from /home/edh/tmp/viper/lib/ast/lambda.rb:32:in `call'
  from /home/edh/tmp/viper/lib/runtime/event.rb:42:in `on'
   ... 8498 levels...
  from /home/edh/tmp/viper/lib/runtime/virtual_machine.rb:73:in `call'
  from /home/edh/tmp/viper/bin/viper:204:in `block (2 levels) in <main>'
  from /home/edh/tmp/viper/bin/viper:204:in `each'
  from /home/edh/tmp/viper/bin/viper:204:in `block in <main>'
dell 
```



Reason: No need for logging with new prelude, import module and load package in :lhome

Might instead print something in the source command Say some :verbose flag.


## Viper flags do all not work

- --finish script has no effect


Reason:  In 2.0.12, 2.0.12.c releases we have switched to ./viper.rb and 
./vish.rb and ./ivsh.rb
These new files use the parseopts function in Vish itself. along wiht mkboolopt, mkvalopt .etc

## 2022-12-13


## eval within an execed lambda within a function does not globalize, if requested

IOW:

1. eval on its own at the top level will set the value of a variable at the top level.
2. eval from within a lambda being execed at the top level will not globalize its variable value
  * But if the string that being evaluated does a "global foo", it works
3. But The same situation being from within afunction body being execed does not work.

```
rem bad code
foo=foo
function dolambda(v) {
  s="foo=:{v};global foo"
  exec &(e) { eval ":{e}" }
}
doit 33
echo :foo
foo
rem should be 33
```

Note: this seems to be the only situation to make it fail

eval 'foo=bar;global foo' within exec &() { lambda call to eval } => within a function body.

But: works ok from old bin/vish and bin/ivsh

```
./vish.rb -s doit.vsh -s mam.vsh -e 'echo :mam' -e 'doit 88;echo :mam' -e 'echo :mam'
99
88
99
vish -s doit.vsh -s mam.vsh -e 'echo :mam' -e 'doit 88;echo :mam' -e 'echo :mam'
99
88
88
```

The last example is correct.



## 2022-11-18


## Investigate why there is both the following 2 ways of invoking Buffer methods:

1. perform env, &block
  * runtime/base_node_command.rb subclasses BaseCommand
2. buf_apply environment args, &block
  * bufnode_buffer_command : subclasses BufferNodeCommand

Hypothesis: The former is meant to be used for any kind of object stored
the VFS, likes arrays, buffers and StringIO objects
The latter is a speciallization of that for just buffers

Note, the @meth member is a curried lambda that is now needing the buffer as the first argument

Note: there are only NoArg and SingleArg commands. Must there was never any need for more.


There must be some reason for this thing.


Reason: the above stated reasons are true.


## 2022-11-16

## If viper -i is set, then also on exit do not ask to save the file

```bash
echo hello world | viper -i
<Ctrl-Q>

# just exits
```





Reason: cannot duplicate


## strange behaviour of echo :exit_status in some edge cases:

```

exit code from glob_setup function was {:__FILE__=>"glob_mkhier.vsh", :__DIR__=>"/home/edh/tmp/viper/vshtest", :exit_status=>true}
```

The offending function was: glob_setup:


```
function glob_setup() {
  mkdir /v/glob
  (groot=":{vhome}/vshtest" source glob_mkhier.vsh)
  (groot=/v/glob source glob_mkhier.vsh)
}
```

The caller was:

```
  glob_setup; echo exit code from glob_setup  was :exit_status
```


Reason: glob was fixed, this is a duplicate bug

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
