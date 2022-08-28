# Viper and Vish Bugs

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

