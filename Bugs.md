# Viper and Vish Bugs

# Todo list

## Create new construct: cmdlet or CommandLet

command lets are short snippets  or strings containing Ruby code

They, once loaded, become like commands stored in /v/bin

```
vish> loadcmd foo '{|*args, ios, fs| ios[:out].puts "foo" }'
vish> foo
foo
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
loadcmd bar '{|args, flags, ios, frames| ios[:out].puts "-f flag is set' if flags[:f] ; ios[:ou].puts "bar called"}'
```

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
# # Complete all shift tests, esp. re: lambdas and functions

## Make sure shift with no args still works ok. Like bash's shift

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


## Vish parser problems

### Parser stops on empty lines. Nothing is processed after a blank line

```
rem a commemt

function foo() { nop }
rem The above and the rest of the file is skipped
```

## doing a 'type of variable with true or false values

```

vish >declarespace=delete equals-pspaceb
b=false
vish >typespaceb
caught exception : undefined method `empty?' for false:FalseClass elsif !frames[args[0].to_sym].empty? ^^^^^^^
vish >
vish >typespaceb
caught exception : undefined method `empty?' for false:FalseClass elsif !frames[args[0].to_sym].empty? ^^^^^^^
vish >typespacea
caught exception : undefined method `empty?' for nil:NilClass elsif !frames[args[0].to_sym].empty? ^^^^^^^
NoMethodError
private method `print' called for "":String


```




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

### Completly remove 'on' as the entire event handlers are not functional

- Also remove the '-l', --log from options and function logger
- The call to load_event is just a 'nop'. Ess ./etc/vishrc
  * Remove all of that

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
# :(echo 1 2)
```

When string interpolation happens, not only should
brace expansion occur, command substitution should also occur.

Is this a parser failure or vish runtime backend failure?


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

## In support of processing. Make a switch/case or match like functionality

Right now, we can use the 'eq' command to  perform this sort of thing, but it has
no break out early on failuer like switch statements.

Proposal is to add another
/v/bin/case command

```
case :flag { when 1 { rem action to perform when :flag is 1 }} { when 2 { rem action to perform  :flag is 2 }} { else { rem action to  be performed when no match occurs }}
```

## Add the ability to /v/bin/test to check for a code block 'test -b { nop} => true'


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


## Bad code smell: lib/bin/capture.rb

There are 3 code blocks passed to capture in *args:
These are named prosecute, sentence and trial
BAD names: Rename to try_block, exception_block and final_block 

# Implement relative require for Vish 'require' command

source ./lib/bin/require.rb


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



## Should handle control plus c in Vish REPL.

And also control plus u to delete the contents of the buffer


## The variable :_status is not available in command mode

It works in the ivsh or Vish REPL and inside functions

But not if said functions are executed in command mode


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

