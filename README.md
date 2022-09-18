# VIPER

## Text and Code editor for use with screen readers

### Version 2.0.9

See the file CHANGELOG.md for updates.

Release 2.1: Indy pre-release candidate #1


## Abstract

This is a simple editor in Ruby that works with screen readers, esp. like VoiceOver 
in Mac OS, or with Orca in Linux with Gnome desktops.
Viper only attempts an audible interface. Sighted users of the program will only see confusing gibberish on the screen.

## Source

<https://github.com/edhowland/viper>

### Wiki

The corresponding Wiki for this project is:

[https://github.com/edhowland/viper/wiki](https://github.com/edhowland/viper/wiki)

## Dockerfile

<https://github.com/edhowland/viper/blob/feature/2.0.0/docker/Dockerfile>



## System requirements



Viper requires Ruby versions: 2.4 and above


### Note on keyboard and Terminal emulators

Viper makes liberal use of  the Meta or Alt key for many of its functions.
Some terminal emulators need to be reconfigured to output the correct sequence
of bytes for a Alt modifier plus key combination.

Before trying to use Viper, check for your terminal emulator's keyboard profile or shortcut settings.
Below find help for terminal emulators that can be used with Viper:

### Gnome Terminal when using the Orca screen reader

Gnome terminal should work out of the box with the Alt key as the meta key.
You may want to change the function key setup, though.
As an alternative to changing the function keys, you may substitute Alt plus 1, 2, 3 ... 0 for  F 1, F 2, F 3 ... F ten.

In addition, the Orca screenreader does not always echo the output from Viper when certain keys are pressed.
This affects the cursor movement keys, the back tab (Shift Tab) and the backspace (Delete back).
As an alternative to these keys, you can alias unbound meta (Alt+) to these keys.
The file in the Viper package orca_alias.vsh maps these for you.
Add the following line to your ~/.vishrc

```
source ":{vhome}/etc/keymaps/orca_alias.vsh"
```


### Orca help

To see a list of what these keys are mapped to: Invoke command mode by
pressing Alt pluss semicolon and entering the following command and then pressing Enter.

```
help orca
```


### Mac Terminal app using Voice Over

Many of the default Option plus key combinations in the Mac OS Terminal application,
output extended characters like the Euro symbol, ellipsis , etc.
Voice over will output the names of these keys.
To get the meta key behaviour, open the Terminal app preferences dialog
by pressing the Command key (the Apple key) plus comma while in the Terminal app.
Select the keyboard tab. Move down until you hear:
Use Option as Meta key checked
Make sure the  option is checked. Exit the dialog by pressing the Escape key.

In addition, you should also add the Page Up and Page Down keys to the keys table.
Set them to output the following text when pressed.

- PageUp : Esc [5~
- PageDown : Esc [6~

Alternatively, you can press Shift plus PageUp or Shift plus PageDown
to get the same effect temporarily.


## Installation

1. Clone this repository
2. cd to the cloned directory: ./viper
3. run bundle to install gems

Note: bundler requires system permissions to install gems in your system
Ruby. I  recommend using a Ruby version manager like 'rbenv' or 'rvm'.
When using a Ruby version manager, your gems get installed locally.

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


## Contributing


Please see the file CONTRIBUTING.md for information on contributing to the Viper project. 
I am looking forward to your support and welcome any help. Together, we can make Viper a great project
for all visually impaired or blind programmers.  I am especially requesting help from programmers in other programming languages like Python, Golang, Javascript, etc.


