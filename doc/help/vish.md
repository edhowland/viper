# Vish - Viper command shell

Vish is the command interpreter for the Viper editor. In fact, most of the 
Viper functionality is written in the Vish shell. This makes it very easy to modify Viper's
behaviour or extend it to meet new capabilities. Also, the command  mode of the Viper
is basically a one line interfaceto Vish. So, any thing written 
in Vish can be invoked or examined in the command mode of Viper.
The command mode can be invoked bia the Alt semicolon keypress.

## Getting Starting

To enter the Vish shell, first launch the command mode with alt semicolon.
In command mode, once you hear the command prompt, type vish , then press Enter. 
This launches the interactive Vish shell, where you can look around, enter new aliases and shell functions and generally just experiment.

To exit the interactive shell and return to the Viper editor, enter vip and then Return key.
Back in the editor mode, you will hear the name of the currnt buffer.


## Launching Vish Interactive shell from the terminal in your current Operating System shell

You can start Vish directly without first launching a Viper editor session.

From the command line in your current shell:

```
viper --no-finish -m com
```

The  flag: --no-finish  informs Viper to not check
for any unsaved buffers and just exit.

### Exiting from interactive Vish shell if invoked
from the outer shell. Just type exit and press the Return key.

## Vish syntax

Vish commands follow the Bash syntax structure closely.

you can enter commands optionally preceded with variable assignments. Then the name of the command
which can be a builtin command, a function or an alias. After the command, you can place any number of arguments separated
by spaces.

### Multiple commands or pipelines

Commands can be separated by semicolons or formed into a command pipeline connected
via the verticle pipe or | symbol.
Also, commands can bejoined together via the boolean separators: two ampersands or two pipe symbols.

### Pipelines

Any number of commands can be connected with pipe symbols.
The standard output of the command to the left of a pipe will be connected to the standard input of the command to the right.

```
echo hello world | cat
```

### Boolean connectors

- && : Two ampersands : Performs alogical and operation on the exit status of each command.
- || Two verticle pipe symbols : Performs logical or operation on exit status of  each command




```
true && false; echo :exit_status
# false
false || true; echo :exit_status
# true
```

### Shortcuts in logical operations

Like in most languages, Vish will attempt to shortcut a logical operation.
A true exit status from the left command in a or operation will not execute the right command.
A false exit status from a left command in and operation will not execute the right command.

This fact can be used to implement a simple if / then construct.
Or an unless tehn construct.


## Alias

Any valid statement or statement list can be aliased as a single command.
When encountered wherever a normal command would be, the aliasis expanded.
This includes multiple statements separated by semicolons or combined in pipelines or grouped by boolean connectors.

Note: In Vish, aliases are treated exactly as in Bash. As such, there is no need
for further explanation. However, here is a simple example:


```
alias hi='echo hello'
hi world
# hello world
alias hi
# alias hi='echo hello'
unalias hi
alias hi
#
alias
# alias k="kill_buffer :_buf"
# alias bk="echo -n Type a key to hear its bound action; bound :(raw - | xfkey)"
# ...
```

## Functions

Vish functions follow the syntax of Bash shell functions. They must be declared explicitly
with the function keyword. Also, parameters to thefunction can be named
and are bound to variables within the function body.

```
function greet(name) {
  echo hello :name
}
hi Ed
# hello Ed
```


Within the body of the function, anyvalid Vish code can be executed. Variables declared as well the value of parameters
go out of scope after the function returns.

### Exit status and return values

Any function or command sets the :exit_status value to true or false upon exit of the function or command.
This differs from Bash which sets $0 to 0 or non-zero correspondingly.
The exit status is used to direct actions in a conditional expression.

```
function good() { true }
function bad() { false }
bad || echo got bad
good && echo got good
```

Note: In the above examples, the :exit_status of the last  command or function is returned as the :exit_status of the function.

If you want to exit early from a function, use the return keyword.

```
function early() {
echo started
return true
echo past return
}
early; echo past early
# started
# past early
```


## Variables

In Vish, variables differ from Bash in some significant ways.
The main difference is the use of the ':' sigil, instead of '$' sigil in Bash to
dereference a variable. Otherwise, actions with variables follow Bash closely.
There are some minor scoping rule differences, though. See [Go to variables](variables)
for more information.


## Commands

In Vish, builtin primitives are called commands. You might have seen 'echo' and 'cat' above examples.
You can think of Vish looking a type of BusyBox executable where the
commands are built in the Bash shell directly. Most of Vish commands look like
their Unix/Linux equivalents.
Each command is implemented as a class in Ruby subclassed from the BaseCommand class. It must
implement the call method to be a working command.

Note: You may create your  own commands an link
to Vish by use of the require and install_cmd commands. E.g.

```
require mycommand
install_cmd Mycommand /v/bin
mycommand arg1 arg2
```

## Anonymous functions or Lambdas

Vish supports a type of function called a a lambda function or just lambda. These are also called
anonymous functions since they do not have a function name. You can set a variable to a lambda or pass a lambda to a command or function.

```
aa=&(var) { echo hi :var }
exec :aa sailor
#  hi sailor
```

Passing to another function:

```
function grabit(fn, name) {
  exec :fn :name
}
grabit &(name) { echo "Hi there, :{name}" } Jack
# Hi there, Jac
```

## Blocks

Statements in Vish can be grouped in a block by enclosing them in curly braces.
Blocks can be directly executed with the exec keyword or passed as an
argument to a function, lambda or command.
Blocks differ from lambdas in that they are  not allowed
to take parameters.
Usually blocks are used in control expressions.

```
loop {
  echo in loop
  break
}
# in loop
```

## Subshells

Statements in Vish can be grouped in a subshell  and are executed as a group.  
This can be useful in conditionals.

```
aa=12
eq :aa 12 && (echo got value as 12;  echo great)
# got value as 12
# great
```

## Subshell expansion

In Vish, you can execute a subshell and its standard output will be returned for storing
in a variable or passed as an argument to a function, lambda or command.

```
name=Betty
aa=:(echo this is my name :name)
echo :aa
# this is my name Betty
```

## Control structures

Vish only has one major control structure, the loop primitive. This can be passed
an block expression which execute infinitely until a break keyword is encountered.
Othere control structures can be composed with this loop and/or conditional expressions.

```
function ifelse(expr, icl, ecl) { (exec :expr || (exec :ecl && false)) && exec :icl }
#
ifelse { false }  } {
  echo got true } {
 echo got false
}
# got false
```

