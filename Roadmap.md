# Viper Roadmap

## The road to version 2.1

## 2.0.11

- CommandLets
- More robust defense coding for out-of-range bugs
  * Investigate the 'at' command

## 2.0.12

### 2.0.12.a

- split up /v/bin  into:
  * /v/editor/bin
  * /v/vfs/bin
  * Add these to paths

See Bugs.md: Todo list

- New external program: vish
  * Break out of viper executable code file
  * split :vhome/etc/vishrc into :vhome/etc/rc.?/{001-999}*.vsh
- abbreviations: Work on the Vish command line
  * inspired by abbreviations in the Fish shell
- :argc, :argv for command line arguments

## 2.0.13

- at_exit code to perform checks.
  * Instead of relying just Ruby's at_exit code to run specified code.
- range, printf  commandlets to beable to load :vhome/scripts/{001-999}*.vsh

## 2.0.14

Argument parsing  for Vish scripts
  * flags for Viper are accomplished in here instead of Ruby in :vhome/bin/viper
- Move more testing to :vhome/vshtest fro :vhome/minitest
  * NiniTests tests  should be reserved for #1 and #2 above. Ruby core and Vish interpreter
  * Need to make Vish code more testable. (Whatever that means)


## 2.0.15

Move all macro and other user specific from :vhome/doc/* to to ~/.config/vish/viper/macros/*
- Move out the MacOS: and Gnome terminal config files to ~/.config/vish/viper/term/*

The above requires  a move to a initialization strategy upon the first step post-installation.

The rationale for this is to prevent users  from clobbering the built-in macro stuff
whenever they perform a git pull to get the latest release.
## 2.0.16

Final wrap-up 

- Better documentation
- More help system internal help


# Goals for 2.1 of Viper

Version 2.0 of Viper marked a major change for the project.
Instead of a Ruby based text editor in the v1.x branch, Viper 2 moved toward an extension language basis.
This is similar to Emacs which is 3 major elements:

1. A C language core
2 A elisp interpreter written in C. Where elisp is a dialect of Lisp.
3. Most of the editor written in elisp.

The advantage of this approach is that core is very solid and has a low maintenance
overhead. The same holds tru for the elisp interpreter.
Elisp is well specified, like most Lisps, and does not accrue many new features over time.
So, the most dynamic aspect of Emacs is probably the  elisp editor code.

The above discussion is probably not 100% accurate, but I think it mostly holds.

Viper 2 took the same approach. For Viper, substitute Ruby for C and Vish for elisp.

However, the 2.0 release did not fully embrace this approach.

Way too much reliance on the aspects of Ruby still exist.

Vish should be:

- Able to be an extension language for more than just Viper
  * An email client
  * A interactive http client
- Run stand-alone scripts to perform utility actions.
- 
