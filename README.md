# VIPER

## Text and Code editor for use with screen readers

### Version 2.0.13.a

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
might be enhanced with a few configuration changes.

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
  * See charm config help for details
- charm help : Describes the charm program and lists its commands with their subcommands 

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
Otherwise, any non-flag arguments on the command line are assumed to be files
or will become new files. Viper, upon startup, will announce the current buffer.
If there are more than one non-flag arguments, the other files will be opened
in subsequent buffers. You can move between them with the : Ctrl-T key. (The Buffer tab key)

### Editing

Viper starts up in insert mode like Emacs.

Type any printable key and it will be added to the current buffer. Control and Meta  or (Alt+key)
keys can be used to control the Viper editor. See the file: [CommandKeys.md](CommandKeys.md)
E.g. ctrl_s will save the current buffer into the current filename. And ctrl_q
will exit the Viper editor andask to save any modified buffers.
F2 speaks the name of the current buffer with its filename.
Ctrl+T will switch to next file entered on the command line. Repeating this key
will continue to move through all buffers and eventually rotate to the first buffer.

### Editor modes

- Insert mode (also called viper mode): The standard mode. This mode is activated when Viper starts up.
- Search mode:  Activated when either ctrl_f (forward search) or ctrl_r (reverse).   Control G will repeat the last search in the last search direction.
- Command mode: Enter a single line of Vish script and it will be executed. See [Vish.md](Vish.md)
  * This mode is also used to open a new filename with the 'o' command.
  * E.g. 'o newfile.txt'
  * You can also save and exit the Viper editor with: 'save; exit', or if in insert mode with the Control q key.

#### Extra modes

These modes can be entered with first entering command mode.

- vish mode: Enters the Vish language REPL. Enter commands or define functions, set variables and inspect things. Hit ctrl_d to exit this mode.


### Other executables

- ./bin/vish : Runs a script a file with extension: .vsh.
  * ./bin/vish -c will check all file arguments  for syntax correctness.
- ./bin/ivsh : Starts Viper in Vish REPL interactive mode. Press Control d to exit or to exit or type 'exit' and press Enter.
  * This can also be invoked within Viper itself via the 'vish' entered in Command mode
- ./bin/charm : The Viper and Vish ecosystem manager

## Warnings

Viper is under active development and as such there is always some possiblility
of file corruption. It is recommended that it is only used in conjuction
a version control system (VCS) like git. If you installe this Viper distribution
via a 'git clone' like mentioned in the Installation section above, then
you already have git. 

One thing that you can do to help protect yourself, besides saving often and using a VCS,
is use the command 'rew' if you get into trouble.

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


