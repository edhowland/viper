# VIPER

## Text and Code editor for use with screen readers

### Version 2.0.12

See the file [CHANGELOG.md](CHANGELOG.md) for updates.

Release 2.1: Indy pre-release candidate #1


## Abstract

This is a simple editor in Ruby that works with screen readers, especially like VoiceOver 
in Mac OS, or with Orca in Linux with Gnome desktops.
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

And there are a few other charm commands that can be useful. Try charm help
for more information.

Recommended approach:

```bash
# This command will create the folder structure unde ~/.config/vish
./bin/charm  config create
# This command will create a PATH string for you to add the ./bin/ folder to your path
./bin/charm config path
# after you have managed your path, run this command to see what else you might configure in Viper/Vish
charm status
# At any time you can get help with any charm command
charm help
# or help with any subcommand
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


## Warnings

Viper is under active development and as such there is always some possiblility
of file corruption. It is recommended that it is only used in conjuction
a version control system (VCS) like git. If you installe this Viper distribution
via a 'git clone' like mentioned in the Installation section above, then
you already have git. 

One thing that you can do to help protect yourself, besides saving often and using a VCS,
is use the command 'rew' if you get into trouble.

1. Invoke Command mode with : Alt+';'
2. Enter rew and press Enter


This will restore the current file from its last saved version on disk.

Please report any bugs encountered via the GitHub issues page for this repository.

[https://github.com/edhowland/viper/issues](https://github.com/edhowland/viper/issues)



## Contributing


Please see the file CONTRIBUTING.md for information on contributing to the Viper project. 
I am looking forward to your support and welcome any help. Together, we can make Viper a great project
for all visually impaired or blind programmers.  I am especially requesting help from programmers in other programming languages like Python, Golang, Javascript, etc.


