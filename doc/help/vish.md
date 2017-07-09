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

you can enter commands optionally preceeded with variable assignments. Then the name of the command
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

### Vish variables

Unlike Bash or similar shells, Vish uses the ':' sigil to represent 
a variable dereference, where Bash would a dollar sign '$' for the same thing.

```
aa=hello bb=world;echo :aa :bb
# hello world
```


#### Variable scopes

Vish also differs from Bash in that variables are locally scoped by default but can be made global if needed.
This only occurs within Vish functions, otherwise, the variable scoping rules match those of Bash.

E.g.

```
aa="hello world"
function hi() {
aa="goodbye world"
echo :aa
}
hi; echo :aa
# goodbye world
# hellow world
```


#### Setting a global variable with global keyword

```
aa=bb
function setme() {
aa=cc
global aa
}
echo :aa
setme; echo :aa
# bb
# cc
```

#### Function parameters vs. variables

Another difference with Bash is that function parameters are named instead of positionally bound and referenced with numerals.
Within the body of the function, these parameter names behave like regular Vish variables and go out of scope 
once the function exits. 

The following examples show the difference between Bash and Vish:

```
# Bash syntax
function foo() {
echo $1 $2 $3
}
foo hello there sailor
# hello there sailor
# Vish syntax:
function foo(gt, pr, name) {
echo :gt :pre :name
}
foo hello world sailor
# hello there sailor
```


#### Referring to all passed arguments to a Vish function

In Bash, you would either refer to allpassed arguments to a function with either $@ or $*.
In Vish this is accomplished with the :_ special variable.
You can use the shift keyword to set a single argument to a new local variable, like in Bash.

```
function bar() {
shift aa; shift bb
echo :aa :bb
echo :_ 
}
bar whats up dude
# whats up
#  dude
```

#### Lexical scoping

A feature in Vish but not in Bash are anonymous functions, also called lambda functions or just lambdas.
Variables set in the enclosing scope wherein a lambda is defined
are lexically scoped within the body of the lambda. Those same variables
may go out of scope once the enclosing scope is destroyed. However, if referenced within a saved lambda,
the body of the lambda retains the value of that variable, even though it does
no longer in scope of the surrounding context.

The usefulness of this type of scoping might not be readily  apparent.
But it comes useful when computing a range of values that you want to save in laambda functions.

In  the Viper editor, we compute the actual values of characters for canonical 
key names and create lambda functions to insert these character values into the current buffer.

An example might be helpful:

```
function make_and_bind(key, char) {
bind :key &() { echo -n :char | ins :_buf } &() { echo -n :char }
}
_mode=viper make_bind key_d 'd'
_mode=viper make_and_bind key_f 'f'
```

#### Statement scoping

For completeness sake, the following example is submitted, althoughthe usage tracks that of Bash.

When variables are set before the name of a command, they are in scope only during the execution of that command.
They go out of scope after the command terminates.

```
function foo() { echo :aa :bb }
aa=hello bb=world foo
# hello world
echo :aa :bb
#
```

Note: the same variables cannot be referenced as arguments to that same command.

```
aa=hello bb=world echo :aa :bb
#
```

#### Unsetting variables

Use the unset keyword to unset a variable. E.g.

```
aa=hello
echo :aa
# hello
unset aa
echo :aa
#
```

#### Listing all set variables

Use the declare keyword to print out the names and values of all currently set varibles.

```
declare
# exit_status=false
# pwd=/home/vagrant/src/viper2
# vhome=/home/vagrant/src/viper2
# prompt=vish >
# oldpwd=/home/vagrant/src/viper2
# version=1.99-rc0
# release=Cleo
#ifs= 
# ...
```


### Variable ranges

A range can be set when a variable is defined. Then, when dereferenced, it is expanded.

```
aa=1..5
echo :aa
# 1 2 3 4 5
```

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
