# VIPER

##  The Accessable, extensible terminal based code editor  for blind and visually impaired developers!

Need a screenreader friendly code editor that even work over SSH or on your daily
driver? Viper will do the job for you.


### Version 2.0.13.b

See the file [CHANGELOG.md](CHANGELOG.md) for updates.

Release 2.1: Indy pre-release candidate #1


## Abstract

This is a simple editor in Ruby that works with screen readers, especially like VoiceOver 
in Mac OS, or with Orca using Linux.
Viper only attempts an audible interface. Sighted users of the program will only see confusing gibberish on the screen.
Viper is designed to work in terminal sessions either directly or over an ssh tunnel.
Viper is not a GUI program.

## Source

<https://github.com/edhowland/viper>



## System requirements

Viper requires Ruby versions: 2.7 and above

### Important Ruby version note:

In the upcoming version of Viper and Vish version 2.0.12 and later, these programs
will require Ruby versions past 3.0. This is because of the use of pattern matching
in later Ruby versions.  Pattern matching was introduced in Ruby 2.7 as an experimental
feature. It was improved in Ruby 3.0. This version of Vier/Vish was tested in
in Ruby version 3.1.2.


## Note on terminal emulators for use with Viper.

Viper uses several keys and their  outputs to control the functions of the editor.
Examples of these are the cursor movement keys, the PgUp, PgDn and Home and End keys
along with many of the Function keys. These can vary between operating systems
and terminal emulators and also with screen readers in the mix.

For more on this see: [Terminals](Terminals.md)


## Installation

1. Clone this repository
2. cd to the cloned directory: ./viper
3. run bundle to install gems

Note: bundler requires system permissions to install gems in your system
Ruby. I  recommend using a Ruby version manager like 'rbenv' or 'rvm'.
When using a Ruby version manager, your gems get installed locally.

### Using rbenv

In this directory where you cloned the viper repository, run the following command:

```bbash
rbenv local 3.1.2
```

Make sure to use correct Ruby version number that you have installed.
Use the highest Ruby version you can safely trust.

To see which Ruby versions that rbenv knows about, do the following:

```bash
cd viper
rbenv versions
```





See the documentation for rbenv to see how to install newer versions:

[rbenv: Manage your app's Ruby environment](https://github.com/rbenv/rbenv)



## Before you start

Out of the box, Viper is a functional code and text editor. However, your usage
might be enhanced with a few configuration changes. For instance, Viper does
not dump dotfiles all over your home directory without you specifically
wanting it to do so.

### Introducing the 'charm'  Viper ecosystem manager

The 'charm' program has been supplied to help you configure Viper and Vish
options. Viper and Vish do not automatically dump various dotfiles over your
home directory or current project directory. Obviously, you can create these
yourself, but charm helps you locate and create them from templates.

Here are some useful charm commands:

- charm status : Displays all the things that charm knows how to report or change
- charm welcome : Shows the Welcome banner and has subcommands to remove it or restore it.
  * display options. The Welcome banner is shown when Viper starts with no files to edit.
- charm config : This command has many subcommands to configure Viper and Vish
  * You may want to start with 'charm config create' which will configure your ~/.config/vish directory
  * See charm config help for details

And there are a few other charm commands that can be useful. Try charm help
for more information.

Recommended approach:

```bash
# You probably want to add viper, vish, ivsh and the charm programs to your $PATH
# Here is one way to do this for the Bash shell. For other shells, YMMV:
echo export PATH=$(./bin/charm config path) >> ~/.bashrc
# You may want to re-source your ~/.bashrc at this point or log out and re-login again.
# The next commands lines assume that the programs charm, vish and viper and ivsh
# are in your $PATH
# This command will create the folder structure unde ~/.config/vish
# It also gives you a ~/.config/vish/rc from a template to get you started with
# additional customizations
charm  config create
# Run this command to check out the current status of your Viper environment
# It will helpfully list other charm commands to run
charm status
# At any time you can get help with any charm command
charm help
# or help with any subcommand. E.g. 
charm config help
```


## Usage

Run viper -h to see a list of command line flags.
Without any non-flag arguments, Viper starts up in editor mode on the buffer : "unnamed1'.
Unless the Welcome banner is still enabled, in which it will be displayed first.
Note: After first cloning this repository, the Welcome banner will be displayed
when there are no files to open on the command line. You can change this behaviour
at anytime by running the the 'charm welcome remove' command.
You can restore the behaviour of displaying the Welcome banner anytime by:
charm welcome restore
Otherwise, any non-flag arguments on the command line are assumed to be files
or will become new files. Viper, upon startup, will announce the current buffer's
name, which is normally the filename.
If there are more than one non-flag arguments, the other files will be opened
in subsequent buffers. You can move between them with the : Ctrl plus T key. (The Buffer tab key)

### Editing

Viper starts up in insert mode like Emacs.

Type any printable key and it will be added to the current buffer. Control and Meta  or (Alt+key)
keys can be used to control the Viper editor. See the file: [CommandKeys.md](CommandKeys.md)
E.g. ctrl_s will save the current buffer into the current filename. And ctrl_q
will exit the Viper editor andask to save any modified buffers.
Control plus l will speak the current line out loud.
The arrow keys will move and speak: right a single character, left a character, up a line or down a line.
Alt plus a will page forward some lines forward. (depends on the value of :pglines, which defaults to 10)
F2 speaks the name of the current buffer with its filename.
Ctrl+T will switch to next file entered on the command line. Repeating this key
will continue to move through all buffers and eventually rotate to the first buffer.
Opening a new file withing the buffer is performed with the Command mode. (See Slightly advanced, but not really expert mode)

### Editor modes

- Insert mode (also called viper mode): The standard mode. This mode is activated when Viper starts up.
- Search mode:  Activated when either ctrl_f (forward search) or ctrl_r (reverse).   Control G will repeat the last search in the last search direction.
- Command mode: Enter a single line of Vish script and it will be executed. See [Vish.md](Vish.md)
  * Command mode is invoked with Alt plus semicolon ';'
  * Any Vish command or compound commands can be run and then be returned into Insert mode
  * This mode is also used to open a new filename with the 'o' command.
  * E.g. 'o newfile.txt'
  * You can also save and exit the Viper editor with: 'save; exit', or if in insert mode with the Control q key.

## Slightly advanced, but not really expert mode

Viper has been influenced by many other code editors, like the EMacs mentioned
above. Another influence has been Vim (or the original vi editor on Unix systems)
In Vim, a lot of stuff happens in Command mode. For instance, saving and exiting
and opening new files or reading files into the current cursor position.
To go from Navigation mode to Command mode in Vim, you press the colon ':'.
And then type some simple commands with arguments. In Viper, since you
are always in Insert mode, you press Alt plus semicolon ';' to temporarily
enter Command mode. In that mode, you also type simple commands  with
optional arguments. After typing the command, you press Return and the
command is performed and you are returned back toInsert mode.
Note: If you open a new file or an existing file, you are in Insert mode
but the current buffer has changed to that file. (You can return to the previous
buffer by pressing Control plus t)

### Some other useful commands entered in Command mode:

- rew  : Reloads the current file from the last saved version on disk
- g (line number) : Goto the specified line. E.g. 'g 100' or 'g 1'
- save : Saves the current buffer. Same as Control plus s in Insert mode
- exit : Exits out of Viper, possibly asking to save any unsaved buffers. Same as Control plus q.
- next; prev : Move forward or backward in the buffer list
- vish : Enters the full Read Eval Print Loop (REPL) for the Vish extension language
  * Note: These are the same as the commands used one at a time in Command mode
  * Actually, Command mode is just a single Read Eval Print without the Loop part

### Unix like commands

Viper in Command mode or in the Vish REPL, has some simple commands like those
found in most shells like Bash on Unix or Linux or MacOS systems.
These commands allow you to move around in directories, list contents of them,
and print the contents of a file or files. 

Note: Vish is not meant as a replacement for the actual terminal or shell
but can be handy to control what where and when Viper does stuff, all under your
control.


- pwd : Prints working directory
- cd dir_name : Changes the current directory Viper thinks it is in
- ls <possible glob list of files) : Lists the current directory contents or those given as arguments.
- cp, rm and mv : Works like their Unix cousins
- cat, tee, head and tail
- sh : Wraps a system command so that can be used with other Vish commands
- for var_name in space_delimited_list_of_files { ... } : Like the Bash for loop
  * But uses braces instead of 'do' and 'done'
- read var_name : Used to get user input or from some previous command in a pipeline
- test [option] object : Like the Bash test, returns true or false depending on option
- cond { test expression } { then statements } else { alternate statements }
  * These statement blocks must come in pairs except for the final else block
  * There must be at least 1 pair of test, then execute block, but there can be any number of pairs

### Command grouping

Vish can group commands together like most Unix shells.  Here are all of the ways:

- ';' semicolon. Groups sequentially, runs each command in turn
- '|' pipe operator : Connects the left command's output to the input  of the right hand command
- '&&' The logical and operator. Only runs the right hand command if the exit status of the left hand command was true
- '||' The logical or operator : Only runs the right hand command if the left hand command returned a false exit status
- (command{s}) : Runs commands in a subshell:.
  * when subshell returns, anything changed in the subshell is forgotten, like cd or variable assignments)
- :(command substitution) : Like a subshell, but any output from the last command is turned into
  * arguments for the current command.
  * Useful in for loops, .etc
- { command[s] } : A command block that is not immediately executed.
  * This is not at all like Bash

### Variables, Aliases and Functions, both named and anonymous and blocks

Vish has variables, aliases and functions like Bash.
Vish also has anonymous functions called lambdas that are first class objects.
They, and also blocks mentioned previously, can be assigned to variables and passed
to functions and returned from functions.

- variables. Assigned to strings and dereferenced with the colon ':' sigil, instead of the Bash dollar '$' sigil.
- aliases : Just like their Bash cousins. Any command or compound command string
- Functions : With both positional and comma delimited named parameters
  * Named parameters are defined in the function declaration
  * Positional parameters are collected in the ':_' internal variable
  * The number of arguments passed to the function or lambda at call time are in ':_argc'
- blocks are any Vish statements  enclosed in curly braces.
  * They are not executed when declared
  * They can be passed to functions or Vish commands
  * They can be stored in a variable or in the Virtual File System and executed later
  * They can be returned from a function

### CommandLets : One liner Ruby scripts that become executable commands

Vish takes inspiration from PowerShell in the form of CommandLets.
CommandLets are short one-liner scripts written in Ruby that become commands
in the executation path of Vish. If Vish has no builtin facility to do some computation,
then it can usually be written in a Ruby one liner. CommandLets have a powerful
API to give access to most of Vish and Viper.

### The Virtual File System

Since Viper is just a Vish script itself, all of its internal data structures
are stored in the Virtual filesystem (VFS). This makes them highly explorable
and manipulable by you or scripts in Vish that you write.

## Viper specific commands and functions

In Viper, which is just a Vish script, there aresome pre-build Vish commands
only used for manipulating buffers and other data structures used by Viper.

- ins : Inserts characters or strings into the specified buffer
- fwd : Moves the cursor some number of characters (usually 1) forward in the buffer
- back : Like fwd but backward in the buffer
-  srch_fwd, srch_back : Searches forward or backward for a string or regular expression
- mark : sets a mark for the named register that can be later used for:
  * Copy
  * Cut

### Additional features of Viper

Although not a comprehensive list, Viper also sports these features:

- Language plugins and support for additiona languages that be added later
- Macros : Used to expand things like code snippets, .etc

... and many more.

### Other executables

- ./bin/vish : Runs a script a file with extension: .vsh.
  * ./bin/vish -c will check all file arguments  for syntax correctness.
- ./bin/ivsh : Starts Viper in Vish REPL interactive mode. Press Control d to exit or to exit or type 'exit' and press Enter.
  * This can also be invoked within Viper itself via the 'vish' command when entered in Command mode
- ./bin/charm : The Viper and Vish ecosystem manager

## Warnings

Viper is under active development and as such there is always some possiblility
of file corruption. It is recommended that it is only used in conjuction
a version control system (VCS) like git. If you installe this Viper distribution
via a 'git clone' like mentioned in the Installation section above, then
you already have git. 

One thing that you can do to help protect yourself, besides saving often and using a VCS,
is use the command 'rew' if you get into trouble. This command, when entered
in Command mode (via the Alt plus semicolon ';'), will rewind the current
buffer to the last saved content on disk or the original file contents
if never saved.

1. Invoke Command mode with : Alt+semicolon
2. Enter rew and press Enter


This will restore the current file from its last saved version on disk.

Please report any bugs encountered via the GitHub issues page for this repository.

## Plugins (and packages)

Viper is meant for editing source code in a programming language.
Most languages have settled on some unique filename extension for their
source files.

1. Ruby :.rb
2. Python: .py
3. JavaScript: .js
4. Rust: .rs

and  many others. Viper relies on this fact to automatically configure
some editor setting specific for each language type. It does this through 
the use of language plugins. Plugins are just Vish packages, no different than
any other Vish package. Remember that viper is just a Vish package.
When Viper starts up, it searches the known locations for plugins and any that
are found are loaded.  There is a one-to-one relationship between the 
filename extension and its plugin. E.g. .rb => ruby_lang plugin.

Viper ships out of the box with 2 plugins:

1. Ruby: ruby_lang => .rb extension
2. Vish: vish_lang => .vsh extension

But many others can be created and will be over time.

You can read more about language plugins and how to create a Python
plugin here: [Plugins.md](Plugins.md)



## The Vish extension shell language

Viper is really just a program written Vish.
Commands entered in Command mode or in your ~/.config/vish/rc or ./.vishrc
files are all written in Vish. When you invoke the Vish REPL either
by running './bin/ivsh' or by invoking Command mode and entering 'vish' and
pressing Return,  you are interactively working the Vish runtime and syntax.

The Vish language looks a lot like Bash and other Unix shells you might
have encountered before. However there are some notable functionality
that has been added and some syntax changes. For more on Vish see [Vish.md](Vish.md)

## The philosophy of Viper


I originally created Viper in the fall/winter of 2015 through 2016 to "scratch my own itch".
I have been using it ever since as my daily driver. But it hasn't gotten any TLC
since then and it badly need some. Also, I have learned a few new tricks
and better software engineering principals. For this reason,
I am working to improve  it with a look to version 2.1 which is what version 2.0 really
should have been back then if I had continued improving. The break has given me some perspective
on how to do it better gradually going forward.

I have collected some thoughts on Viper and general development precepts here: [Philosophy.md](Philosophy.md)
I hope you might share some of them and strive with me to make the world
better for blind and visual impaired programmers in the future.
Thank you.





## Contributing


Please see the file CONTRIBUTING.md for information on contributing to the Viper project. 
I am looking forward to your support and welcome any help. Together, we can make Viper a great project
for all visually impaired or blind programmers.  I am especially requesting help from programmers in other programming languages like Python, Golang, Javascript, etc.


