# Viper Roadmap

## The road to version 2.1

## 2.0.11

- CommandLets
- More robust defense coding for out-of-range bugs
  * Investigate the 'at' command


Released on 2022-11-20


## 2.0.12

### 2.0.12.0: fast open

See Todo list in Bugs.md for ideas on implementation.
Basically, current File open is not the correct way to insert the file data into the buffer.

### 2.0.12.a

- split up /v/bin  into:
  * /v/vfs/bin
  * /v/viper/bin
  * Add these to paths


Finished: 2022-11-29

### 2.0.12.b

Note: See mini-2.0.12.b-Roadmap.md for extensive details on this release.

- New external program: vish
  * Break out of viper executable code file
  * split :vhome/etc/vishrc into :vhome/local/vish/prelude/001..009_*.vsh

Note: See ./pry/load_scripts.vsh for how to do this.



- :argc, :argv for command line arguments
- Some sort of get_opt - style parsing to take ove the command line args for bin/viper : OptionParser


Also created ./ivsh.rb to replace ivsh REPL.

### 2.0.12.c

Though partially noted above, this interim release will create the viper import module

A new Ruby loader called viper.rb  will execute :

```ruby
veval 'load vip', vm: vm
```

The load command is created to load packages in ./local/packages
The 'vip' package is a meta package that also loads the 'viper' package.
This allows for the 'viper' package to stand on its own in ./vish.rb (for use in vshtest testing)
and ./ivsh.rb to allow for experimenation with launching the main Viper run loop.

Note: See mini-2.0.12.c-Roadmap.md for extensive details on this release.





Finished on 2023-01-03


### Release 2.0.12

Finished on 2023-01-19


## 2.0.13

(Was formerly 2.0.15)

Move all macro and other user specific from :vhome/doc/* to to ~/.config/vish/viper/macros/*
- Move out the MacOS: and Gnome terminal config files to ~/.config/vish/viper/term/*

The above requires  a move to a initialization strategy upon the first step post-installation.

### Create new Vish application: vupdate, or vishup

Application takes command like 'go new' or 'cargo new'

Note: This above is now renamed to 'charm', a Vish app

```bash
charm help
charm start # creates initial ~/.config folders
charm update # aliased to charm up Checks for package updates
charm install package
charm ls # lists installed packages
charm test [test_name] # or run all Vish tests
# and many more ????
```


- vishup init : Creates ~/.config dirs, and copies sone ./local user updatable content therein
- vishup packages ls - Lists currently known packages with pathnames
- vishup modules ls - list currently known modules
vishup paths ls - list known Vish paths for executables (:path), modules (:mpath) and packages (:lpath)
vishup test - runs all tests or just selected tests in vshtest/ dir.
- vishup startup ls - Lists the initialization startup order: ./local/boot, ~/.vishrc, :proj/.vishrc
The rationale for this is to prevent users  from clobbering the built-in macro stuff
whenever they perform a git pull to get the latest release.

- Fix broken help system

Currently based on parsing MarkDown files in :vhome/doc

The help system should be made more just pure Vish code
Of course, this requires the above Vish changes. E.g. argc, argv and locating things in .config/vish
Help should be made portable, meaning across OSes and allowing for user contributed help strings


Q: Can Vish functions contain docstrings like Python?

- add man pages
Implement the man page style for vish commands

/v/man/1/cd,mv,tee ... .etc

Also Markdown files
Built from the RDoc strings in Ruby source code in :vhome/lib/bin/*.rb


## 2.0.14

- run prettier -ruby on code base
- run rubocop
- Invistigate the new Ruby type syntax
  * DO NOT let this run down a rabbit hole
  * Perhaps, if not easy to backport, wait until Viper 2.2


## 2.0.15

Final wrap-up 

- Better documentation
- More help system internal help
  * create man command to work from viper docs/wiki
- Complete Todo items from Bugs.md marked with a '*'
  * These are must-haves for 2.1



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
Where Vish is the Viper extension language with a Bash style syntax.

However, the 2.0 release did not fully embrace this approach.

Way too much reliance on the aspects of Ruby still exist.

Vish should be:

- Able to be an extension language for more than just Viper
  * An email client
  * A interactive http client
- Run stand-alone scripts to perform utility actions.
- 


## What Viper 2.1 is NOT!

Viper 2.1 is not a major rewrite of Viper 2.0, despite 2.0 being about 6 years old at this point.

The Ruby is quite smelly:

- VFS (Virtual File System) should just be a simple Hash with both '.', and '..'
pointers. (Not easy to do unless you introduce thunks, or defer lambdas

- Vish syntax has a few definciencies:
  * Subshells should be able to be used anywhere in a statement. The return code (:exit_status) is supplied for the argument at that argument position.
  * There should be redirection primitives like 2>&1, or 1>&2.
  * Within double-quoted strings, the command substitution should be interpolated:

```
echo "hello :(echo world)"
hello world
```


### Viper problems

- The current of meta/mode switching is truly broken.
  * Relies on raising an exception and using a single array: /v/meta
- Newer modes like a Vim-like mode are not able to be implemented herein.




These, and a slew of needed refactors, need to be made, but will be reserved for 2.2 and beyond.