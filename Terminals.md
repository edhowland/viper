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

