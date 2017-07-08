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


