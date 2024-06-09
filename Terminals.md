# Terminals

## Abstract

Viper is meant to be used as a command line application. It can be used locally
on your Linux workstation or on a Mac desktop. It might work on Windows
but I have no ability to test this. It can also be invoked over a SSH session.
In that case, you would need to install it on the remote session, along with Ruby
and the Viper dependancies via the supplied Gemfile with Bundle.

This documents the possible problems you might encounter
with terminal emulators on these workstations.

### Important note: The workstation terminal emulator mentioned below is the one connected to your physical keyboard.

In other words, if you SSH into a Linux box, install Viper there, and then
use it to edit files on that box, the terminal emulator is your local local physical
workstation, not the remote's installed terminal emulator.


### Note on keyboard and Terminal emulators

### How Viper goes about determining which keymap to use

As previously mentioned, Viper is just an application written in the Vish
shell language. There is some Ruby runtime involved but most of the logic
is written in various .vsh files [the extension for Vish scripts].

There is a  builtin command 'load_termfile' which will read the appropriate .json for your current terminal.

[The terminal you are currently are typing on, not the terminal in the remote Viper session if running over ssh.]

This is determined by the $TERM_PROGRAM shell environment variable.
This environment variable is passed thru to a remote ssh session, so even if you
are running Viper over on the remote, it will map keys to the terminal you
are physically typing on locally.

To see which keymap is currently in use on whichever session is in force
run this command before starting Viper:

```bash
viper -e 'echo :termfile'
```

Then press Control-Q to exit Viper.

You should see something like

```
<viper-distribution>/local/etc/keymaps/<your-terminal-name>.json
```



 
##### Using the 'ivsh' REPL to see if you have the right :termfile

By default, both the ./bin/vish script runner and the ./bin/ivsh REPL do not
automatically load the :termfile  upon start so they can be used for debugging.
But, you can play around  after starting './bin/ivsh':

```
import keymaps
echo :termfile
```



#### Viper uses three variables to determine which keymap to load:

- :lhome => The current localtion of './local/' in your Viper distribution
- :term_program => ...  Loaded from $TERM_PROGRAM when the virtual machine first loads.
- :termfile => {lhome}/etc/keymaps/{term_program}.json

This all happens in the keymaps module which is located in:

```
ls ./local/vish/modules/keymaps/
```


Once the correct :termfile is in place, Viper must then map actual keys
to actions  to be performed in the editor, e.g. deleting the previous word.

Basically, the actual raw characters sent by the terminal to Viper are mapped
to canonical strings in the above mentioned .json keymap file specified by :termfile.
Which actual action is performed is determined by the current mode currently
 in force at the time the key is pressed.

For a more complete explanation of this process, please see : [Keys.md](Keys.md)


## Viper makes liberal use of  the Meta or Alt key for many of its functions.
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



#### The environment variable TERM_PROGRAM in MacOS with the Terminal.app

If using the Terminal.app which ships with MacOS, it will probably set the $TERM_PROGRAM to "Apple_Terminal".

In Viper 2.0.13.c and earlier, Viper will try to use this keymap which
is located in ./local/etc/keymaps/Apple_Termina.json

This will severely limit what keys are available to Viper.
For instance any key combos that use the Alt key [The Option key on the Mac keyboard]
will simply report that the key is unbound and not actually do anything.

To suppress this behaviour in this set of circumstances, change how you
invoke viper:

```bash
TERM_PROGRAM=xterm viper
```


