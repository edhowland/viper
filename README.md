# VIPER

## Text and Code editor for use with screen readers

### Version 2.0.12.c

Beta release for 2.0.12

See the file [CHANGELOG.md](CHANGELOG.md) for updates.

Release 2.1: Indy pre-release candidate #1

### Important information regarding this patch.point release.

The patch point releases: 2.0.12.a, 2.0.12.b and now 2.0.12.c contain minor code
changes to the base in ./lib/*/*.rb. Most of the major changes are occurring on
the ./vish.rb, ./ivsh.rb and ./viper.rb executables. The original: ./bin/vish, ./bin/ivsh
and ./bin/viper are essentially the same as their 2.0.11 ancestors, with the
minor changes mentioned above.

Testers of the .12.a,b and c variants should focus on these 3 files in the root
of this repository. Once 2.0.12 is formerly released, then the .rb files will
replace in ./bin with no .rb extension. The former executables will be deprecated
and placed in the deprecated folder until 2.1.0 is released, at which point they will be removed.


## Abstract

This is a simple editor in Ruby that works with screen readers, especially like VoiceOver 
in Mac OS, or with Orca in Linux with Gnome desktops.
Viper only attempts an audible interface. Sighted users of the program will only see confusing gibberish on the screen.

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


## Usage

Run ./bin/viper --help to see a list of command line flags.
Without any non-flag arguments, Viper starts up in editor mode on the buffer : "unnamed1'.
Otherwise, any non-flag arguments on the command line are assumed to be files
or will become new files. Viper, upon startup, will announce the current buffer.
If there are more than one non-flag arguments, the other files will be opened
in subsequent buffers. You can move between them with the : Ctrl-T key. (The Buffer tab key)

### Editing

Type any printable key and it will be added to the current buffer. Control and Meta keys
can be used to control the Viper editor. See the file: CommandKeys.md
E.g. ctrl_s will save the current buffer into the current filename. And ctrl_q
will exit the Viper editor andask to save any modified buffers.
F2 speaks the name of the current buffer with its filename.
Ctrl+T will switch to next file entered on the command line.

### Editor modes

- Insert mode (also called viper mode): The standard mode. This mode is activated when Viper starts up.
- Search mode:  Activated when either ctrl_f (forward search) or ctrl_r (reverse). Previous search queries can be accessed with the up and  down arrows. See Searching.md
- Command mode: Enter a single line of Vish script and it will be executed. See Vish.md
  * This mode is also used to open a new filename with the 'o' command.
  * You can also save and exit the Viper editor with: 'save; exit'

#### Extra modes

These modes can be entered with first entering command mode.

- vish mode: Enters the Vish language REPL. Enter commands or define functions, set variables and inspect things. Hit ctrl_d to exit this mode.
- pry mode. Enters the pry Ruby debugger. This mode is for advanced debugging. Hit ctrl_d to exit this mode.



#### Extra modes

See the file: Modes.md for a more complete list of various modes.

### Other activation modes for Viper

- ./bin/vish : Runs a script a file with extension: .vsh.
- ./bin/ivsh : Starts Viper in Vish REPL interactive mode. Press ctrl_d to exit or type 'exit' and press Enter.


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


