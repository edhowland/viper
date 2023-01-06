# Vish

## Abstract

Vish is the command language of the Viper code and text editor.
Most features of the editor are implemented as Vish commands. For instance,
a keypress is bound to an execution block. When the key is pressed,
it is looked up in the current mode and then the code block is executed.

## Vish modes in the standard Viper insert mode.

When Viper is invoked, it starts up in insert mode. In this mode, there are
2 ways to interact with the Vish language.

1. Command mode
2. Vish REPL or the Read-Eval-Print-Loop interactive mode.

## Vish is similar to Unix shells you may have used recently.

For instance, common Vish commands like 'cd', 'ls', 'cp', and 'rm' work much like
their Unix shell cousins. Vish also supports variables, aliases and functions.
Vish also handles file redirection and pipelines. E.g. want to insert a file
into the current buffer at the cursor? Here are 2 easy ways to do this:

```
ins :_buf <foo.txt
cat bar.txt | ins :_buf
```

The ins is a special Viper command that inserts at some buffer. The variable
':_buf' refers to the current buffer.

## Invoking the Vish REPL to look around

There are 3 ways to invoke the Vish Read-eval-print loop or REPL.

1. In Viper itself: Press Alt + ';' to invoke a Command mode.
  * This will allow you to enter one line of Vish code which will be evaluated and then return you to Viper.
  * Note that you can invoke multiple commands by separating each with a ';'.
  * Or you can enter a complex pipeline of commands.
2. Once in Command mode, enter 'vish' and press Enter.
  * This will drop you intothe REPL where you can enter as many Vish commands as you want.
  * Press Control D to return you to Viper insert mode.
3. Instead of going through Viper, you can invoke ./bin/ivsh and you will launch the REPL directly.
  * Press Control D to exit back to your usual shell, like Bash.

## Running Vish scripts directly

Any Vish code written in a file  can be invoked with the ./bin/vish executable.

You can treat these as shell scripts that can be used whereever you might use a
Bash shell script. Or for programming tasks you might use Ruby or Python for
similar tasks.


Warning: Vish is not a replacement for Bash scripts.
At this time, Vish is missing several control structures that Bash has. It does have

- cond statement. A multiple conditional  statement like that found in the Scheme language.
- for loops
- A generic 'loop' construct with a break statement.

It does not have:

- while loops
- case statement.







In all three executables: ./bin/viper, ./vish and ./bin/ivsh  the options '-s' and '-e'
are recognized.

- '-s file.vsh' : Will load and source file before any interaction starts.
- '-e "some_vish_command arg1 arg2; cmd2 arg3"' : Will evaluate this string before any interaction starts.

Both of these options can be be repeated as many time as needed. All '-s' options
are processed before all/any '-e' options are  processed.


## Variables

Vish variables act almost like their Bash cousins. All variables are of type
string except for the special values: 'true' and 'false'.
Variables can be dereferenced via the ':' sigil being placed befor the variable name.

```
avar=foo
echo :avar
foo
```

All variables are global by default unless they are created in inside the body
of a function or a lambda. Variables of the same name as a global variable
defined inside the body of a function or lambda will shadow the global variable of the same name
until the function returns. If the 'global varname1 varname2' is placed
after the variable definition, that variable is now set in the global namespace.

### Special variables

Vish and Viper set many special variables when they start up. These can be
used for many purposes. If you change them, you may override their meaning.

```
prompt='Ivish >>'
```

Now the prompt in the REPL will be: 'Ivsh>>'

###f Setting variables in in source files.

Any variables declared in a file of Vish source code and then loaded by the 'source' or '-s file.vsh' option
will become global variables.
This is not true for variables set in the '-e "foo=bar"' option.
But can be made global via the 'global' statement.

```bash
ivsh -e 'foo=bar; global foo'
vish> echo :foo
bar
```




Variables set inside either a Vish sub command or  a command substitution will not persist
once the sub command exits. This can NOT be overriden by the 'global' command.

## Functional programming constructs

Vish has 2 ideas imported from functional programming languages.

- First class executation blocks.
- Lambdas

Both of these can be stored in a variable or passed to a function.
They also both can be stored in the Virtual File System (VFS). See below.

A block is never executed unless explicitly.

```
ablock={ echo I am a block }
exec :ablock
I am a block
```


Lambdas are closures. They capture the state of variable binding at the time they are created.

```
foo=bar
my_lamb=&() { echo :foo }
foo=baz
echo :foo
baz
exec :my_lamb
bar
```


## The Virtual File System

When the Vish runtime gets going, a kind of virtual file system is "mounted" in the pseudo directory: '/v/'.
Almost all of Vish and Viper data is stored somewhere in the VFS. For instance theViper
buffers are stored therein.  

Note: Many more things besides files and directories can be stored the VFS.

- Buffers, like file buffers and scratch buffers.
  * The (more than 1) clipboard is a buffer.
- Arrays
  * The buffer ring is one such array.
- Blocks and lambdas.

Most of Viper is just functions that manipulate files, directories, buffers, arrays
and executable blocks and lambdas stored in the VFS mounted at '/v/'.
Invoking the REPL is one way to inspect these many data structures in Vish or Viper.

### A praticle example using Vish and the VFS

Assume you have been doing some editing of a file. And you want to take some
lines from inside that file and write it out to some other file. One way you
might think of to accomplish this is the following:

1. Mark a starting point with the  F4 key
2. Move the cursor to the end of the section you want to copy
3. Press Control C to copy this into the clipboard.
4. Invoke Command mode with Alt + ';'
5. Enter: 'o newfile.txt'
6. Press Control V to paste the contents of the clipboard into this new buffer.
7. Press Control S to save the file to its file name (you assigned with the "o newfile.txt" earlier).
8. Press Control T to move to the tab containing your original buffer.

However, you can shortcut the above actions from step 4 through 8 as follows:

4. Invoke Command mode with Alt + ';'
5. Enter the folloing command: 'cat < :_clip >newfile.txt'



The ':_clip' variable is a pointer to the current clipboard which is itself just a buffer
like the one you are editing.



## Key bindings

In either vish or in the ivsh REPL, there are no defined key bindings. Once you load
 the 'viper' package, the Viper key bindings are created for various Viper
editing modes.  Like most things in Vish and Viper, these are stored in the
VFS mounted at '/v/'.

What is a key binding?

Whenever you press a key in the Viper edit mode like the 'insert' mode,
the key is looked up in the current mode (defined by the :_mode variable)

E.g. If you press 'J', you get a key named: 'key_J'.
This is a file in the following directory:

```
/v/modes/viper/key_J
```





We can stat this file:

```
stat /v/modes/viper/key_J
stat
/v/modes/viper/key_J
virtual? true
directory? false
Lambda: &() { ins :_buf :ky }

```

We see from above that this is a Vish lambda.


The lambda when it is invoked after you have pressed the 'J' key actually inserts
the 'J' character into the  current buffer  ':_buf' using the ins Vish command.


### The spoken output of the key binding

We probably want the Viper editor to speak the character we pressed as well as inserting
into the current buffer. This is handled via another

```
stat /v/views/viper/key_J
stat
/v/views/viper/key_J
virtual? true
directory? false
Block: { cat }

```

In this case, the executable file in the the '/v/views/viper/key_J' is a
block instead of a lambda. Either a lambda or a block can be bound to 
some key action. Why would we want a lambda over a simple block?
Note that in the key_J lambda in /v/modes/viper/key_J
contains a variable ':ky'. This variable is defined
when the lambda was first constructed. All Vish lambdas are closures.
The same lambda is constructed and stored for all insertable characters
and stored in /v/modes/viper/key_*. That way we can just run a loop over a range of
characters and store then inside each lambda's :ky' closed variable.

Here is an example of how we might accomplish this.
This is similar to actually how Viper does this:.

```
_mode=viper for ky in "a" "b" "c" "d" {
  store &() { ins :_buf :ky } "//v/modes/:{_mode}/key_"{ky}"
  }
```

### Understanding the canonical names  of keys

All keys entered  in Viper are translated into their canonical key names.

You can check a key by invoking Command mode and entering the following

```
raw - | xfkey
meta_l
```

The canonical prefixs are:

- key_
- ctrl_
- meta_
- fn_

... followed by the name of the key. For non-printable characters, the English name is used

```
raw - | xfkey
meta_semicolon
```

Alt + ';' was pressed. The key combo for the Command mode.




### Checking how a particular key is bound.

You can use the 'bound key_x' function to see how a key is currently bind in some mode:
Set the _mode variable before invoking the bound function.
Pass the canonical key name.
If no key is bound in that mode, an error will be reported.

You can see if a key is bound with the 'is_bound' function:

```
_mode=viper is_bound :(raw - | xfkey); echo :exit_status
true
```

Control ! was pressed.

In the above example, we set the _mode to the viper mode, then invoked
the is_bound function and passed the result of performing the a command substitution with raw - piped into the xfkey command.
Then we pressed Control Q. Finally we printed the value of the exit_status variable.
After every function is called, it sets the value of :exit_status.

You can use this behaviour to conditionally perform some action.

```
_mode=viper is_bound ctrl_d && echo Control D is bound in mode viper
```

Nothing is  printed because ctrl_d is not bound in _mode viper.

```
_mode=viper bound key_J
_mode=viper bind key_J &() { ins :_buf :ky } { cat }
```





The output of the 'bound' function is a  a string that is valie Vish code that
is actually  ran somewhere in the Viper startup code. The first parameter passed
to the bind function is the lambda mentioned above. The second parameter is the block located
in /v/views/viper/key_J.

From the above discussion, we can see how to bind our own keys to executable actions.

### A practical example

Let's say that every time we want to press the Control D key the current date and time is inserted in the current buffer
at the current cursor. As of version 2.0 through 2.0.12, the Control D is not bound

```
_mode=viper bound ctrl_d
ctrl_d is not bound
```

Note the first parameter passed to the 

First step: 

We'd like to make the date function do our bidding, but there is no 'date' command or function
defined in Vish or Viper.
We could create such a thing, but how can we make it permanent for each future Viper session.

### The Vish runtime startup

After Vish gets started and its standard library has been loaded, it looks
for 2 files and if found, loads them in this order:

1. ~/.vishrc
2. ./.vishrc

The first file in your home directory, if found is loaded and any Vish
source within is evaluated in every Vish context. This includes ./bin/viper,
./bin/vish and ./bin/ivsh. You can set variables, declare functions and define aliases in this file.

The second file : './.vishrc' performs the same functionality as that in your
home directory but it is specific to your project directory and will override any
settings set in ~/.vishrc. We will place our date function in this file: '$HOME/.vishrc'

In $HOME/.vishrc:

```
alias date="sh date"
```

Now try this out:

Start up ./bin/ivsh and enter the following:

```
date
Thu 05 Jan 2023 07:58:28 PM EST
```

If you have did all the above, you should see something similar to the above date command.

Note: The 'sh ' prefix placed before any command in Vish will spawn the system 
command and pass all of its arguments to the system command.

E.g.

```
mkdir foo
touch foo/t1 foo/r2 foo/g3
sh rm -rf foo/
ls foo
ls: foo: No such file or directory
```

The contents and the directory foo have been  deleted.

#### Binding our new date command to the Control D key combination

At this point we can bind our date alias to our key with the following command.

Invoke Command mode with Alt + ';'

```
_mode=viper bind ctrl_d { date | ins :_buf } { cat }
```



Then try it out. Move the cursor where  you want your date and then press Control + 'd'

Note in the above example, the view block executable is just:

```
{ cat }
```

This is because the output of the date being piped into the ins :_buf command
is normally echoed by the ins command. You can suppress this in 2 ways:

```
_mode=viper bind ctrl_d { date | ins :_buf } { nop }
```

In the above binding, the view block is just the 'nop' command which
stands for 'No OPeration'.


Here is another way to do the same thing.

```
_mode=viper bind ctrl_d { suppress { date | ins :_buf } } { echo -n  Current date inserted }
```

Any commands executed in the block passed to the 'suppress' command will not
not be output to stdin. Then we just report that the date has been inserted.



## Conclusion

Hopefully, this exploration of the Vish language and its usage within the Viper
editor has given you some ideas for further  investigation. We have seen
that Vish is similar to Bash and other Unix shells, but differes in some unique ways.

Vish has:

-A Virtual Filesystem (VFS) that can store any sor of object.
- First blocks that be passed to commands and functions or saved in the VFS
- Lambdas that be stored in variables, the VFS or passed to functions or even other lambdas.
  * and are themselves closures.
- A nicer syntax for things like for loops.
- functions with actual parameter names
  * but still collects extra arguments passed to the ':_' internal variable
  * All variables are local to the function by default but can be promoted to global by the 'global command.
  * values other than a single byte  can be returned from a function. Default is to return the 'true' special value.
- The ability to shell out to any system command and then alias that to a Vish command.


Note that blocks, (commands  surrounded by '{' and '}') are deferred
until they are explicitly executed:

```
a_block={ echo I am a block }
rem this is a comment
rem ... later
exec :a_block
I am a block
```

This means there is an almost infinite combination of ways you can use these in
other function call contexts. Most of the control structures of Vish are
implemented with these lazy blocks.
