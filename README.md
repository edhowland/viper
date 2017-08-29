# VIPER

## Text and Code editor for use with screen readers

### Version 2.0.0

Releas : cleo

## Abstract

This is a simple editor in Ruby that works with screen readers, esp. like VoiceOver 
in Mac OS, or with Orca in Linux with Gnome desktops.
Viper only attempts an audible interface. Sighted users of the program will only see confusing gibberish on the screen.


## System requirements



Viper requires Ruby versions:

- ruby 2.2.2p95
- ruby 2.3.1p112
- ruby 2.4.1p111

Or similar versions of Ruby.

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
pressing Alt pluss semicolon and entering the following commmand and then pressing Enter.

```
help orca
```


### Mac Terminal app using Voice Over

Many of the default Option plus key combinations in the Mac OS Terminal application,
output extended characters like the Euro symbol, elipsis, etc.
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

## Contributing


Please see the file CONTRIBUTING.md for information on contributing to the Viper project. 
I am looking forward to your support and welcome any help. Together, we can make Viper a great project
for all visually impaired or blind programmers.  I am especially requesting help from programmers in other programming languages like Python, Golang, Javascript, etc.


