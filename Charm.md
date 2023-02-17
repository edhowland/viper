# Charm the Viper ecosystem management utility

## Abstract

Charm is the overall ecosystem manager for the Viper code and text editor environment.
In fact, it really covers the entire Vish installation on your machine.
Inspired by cargo for the Rust language and go for golang, charm helps
users and especially new users with setting up the Viper environment post installation.


## Why is charm needed?

Although, Viper out of the box is sufficient for most editing tasks,
users may want to extend or customize their Viper functionality.

Classically, this has been done via '*rc' files, like ~/.vimrc or 
or the EMacs init file: ~/.emacs. Viper also has this
ability through its own init file named: ~/.vishrc. 

Note the name of the file here: .vishrc. This should clue in to the fact that
this file probably contains Vish program code. In fact, any Vish source code can
be in a .vishrc file which gets loaded before any other Vish packages are loaded.
(Remember, like EMacs is really just a bunch of ELisp code running on
on the elisp core engine, so to is Viper just Vish code running on the Vish core)

### Local .vishrc files

In addition to  your .vishrc file in your home directory, if any ./.vishrc files
exist in some project directory where you are editing files, settings
within that file will override any settings in ~/.vishrc which override any
settings in the core Vish system.

## The movement away from dozens or hundreds of dot files in your  home directory

Modern Unix/Linux software is slowly migrating from over-populating your home
directory with every application's own (usually set of) various dot files.
The new trend is to corral them into a single directory: ~/.config.
This trend is actually based on the XDG specification from the site: [Free Desktop.org:https://www.freedesktop.org/wiki/](https://www.freedesktop.org/wiki/)
XDG means the Cross Desktop Group set of specifications for interoperability among
suppliers of Desktop GUI software.





### The XDG directory specification



The trend of moving configuration files like '*rc' files into a single
top-level directory : ~/.config is spelled in this document: [https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html](https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html)


### Viper trys to be polite about not place dot files on your system without informing you first.

Hence the need for a different program: 'charm' to help you manage these files for you.




### Why is it called charm?
The name 

Well, how do you control a snake? With a snake charmer, of course!


## The charm program

The charm program consists of the  charm executable in './bin/charm'.
This program only runs if given a command with possible subcommands One such
command is 'help' which introduces  you to the charm program.



```bash
$ charm help
charm is the Vish (andViper) ecosystemmanager.
The charm command provides many subcommands that perform multiple actions related to the
Vish and Viper package and environment.
Available charm subcommands

Subcommands, if any, are enclosed in square brackets like charm welcome [restore]
Every command listed below also has a [help] subcommand that is not listed.


charm status : Displays  current status of the Viper ecosystem
charm config [create] {vishrc] [project] [ignore] [path] [alias] : 
  Creates local  Viper/Vish config directories and .vishrc files
  Can also be used to help set your $PATH or aliases to viper and vish programs.
  And helps with adding ./.vishrc to your .gitignore file if needed.
charm package [ls] [new] [test] [install [path]] : 
  Lists extant, creates new, tests and installs packages
charm module [ls] [package] [new] :
  Lists known modules thatt can be imported with 'import module'
  Can use charm module package package_name to list modules within a package
  The new subcommand will create a new module and populate with some template sample files
charm welcome : [remove] [restore] :
  Displays the Viper startup banner. Or removes it or restores it at startup.
charm help displays this help text
```





### charm status

The first command of note is the 'status' command. This command has a  lot of
informational content about the entire Viper/Vish ecosystem.
Additionally,  charm status will helpfully suggest other charm commands to setup
further Viper/Vish configurations


## charm config

This is probably the place to start your Viper/Vish configuration journey.
The charm config command has many subcommands:

```bash
$ charm config help

The charm config command helps sets up the Viper/Vish ecosystem.


## Abstract

Out of the box, Viper is a fully operational text and source code editor.
However, it tries to be polite to new users who might not want it to dump
a lot of dot files in their home and source code project directories.
To this end, the charm command allows you to query and adjust the configuration
of the Viper and Vish ecosystem.


## Available charm config subcommands

### charm config create

The create subcommand will create  a new subdirectory in your ~/.config directory called vish
In that new directory are two subdirectories

- packages
- plugins

Vish, and Viper by the fact it is just a Vish program, will search this directory
 for installed packages and plugins in priority over the default Vish package
search path.

Note: The Vish package search path for the 'load package_name' command is :lpath.
By maintaining this :lpath variable, you can locate packages which you may have
downloaded or created yourself.


You can check if this directory structure is known to the Vish  by invoking:

charm status


### charm config path

This subcommand will construct a new $PATH variable for you. You can
then append it to your ~/.bashrc or the startup script for your shell.

E.g.

```bash
# In Bash shell:
echo export PATH="$(charm config path)" >> ~/.bashrc
```



### charm config alias

Instead of munging your $PATH environment variable, you may want to create
a series of  aliases instead. This is where 'charm config alias' comes in.

E.g.

```bash
# Again, for Bash shelll:
charm config alias > viper.alias
source viper.alias
# Or, for a more permanent solution:
charm config alias >> ~/.bashrc
```


### charm config vishrc

This subcommand 'vishrc' will copy a sample .vishrc template to your
home directory. It will not overwrite one if one already exists.
To see if you already have a  ~/.vishrc either do 'ls ~/.vishrc' or 'charm status'

Any Vish statements including variables, aliases and functions can be placed
inside your ~/.vishrc. They will override any matching default elements of Vish.

## charm config project

The 'project' subcommand will perform the same action as 'charm config vishrc'
but for your current directory, placing a ./.vishrc from a sample template
in your current project directory.


Note: If git is installed and the value of the variable of :no_use_git is false,
then charm config project will also invoke the 'charm config ignore' command which
will place ./.vishrc in your .gitignore file.
If you have either set no_use_git=true in any of   your .vishrc files, it will not
perform this action.




### charm config ignore

Issuing this command in a project directory that is also a git repository
will cause any Vish dotfiles in this directory to be added to your .gitignore file.
Currently, this is only ./.vishrc 

## charm config help

Displays this message.
```




### What to probably do first:

You probably want to initialize your ~/.config/vish folder.
This folder acts as the storage for Vish's (and Viper's) packages and plugins.

See the document: [Plugins.md](Plugins.md)

If you either download a new programming language plugin or write one yourself,
you would like to keep these around even you might later re-install Viper or
perform a 'git pull' in the Viper source directory.

```bash
$ charm config create
```

Now this folder structure should exist:

```bash
ls -1R ~/.config/vish
# TODO populate this ls output
```



### The Vish init files: ~/.vishrc and ./.vishrc

Even though I previously said there is a trend of moving away from overpopulating
your $HOME directory with dot files like '.*rc' files, Viper was written
in 2016 before I knew about this trend. Therefore, Viper/Vish still
looks for ~/.vishrc. Pehaps
## charm welcome

When Viper starts with no files to open on the command line, it will display a Welcome
banner. You can see this banner with  either starting viper:

```bash
$ viper
```

or by running this charm welcome command:

```bash
$ charm welcome
```



You may or not wish to always see this banner. This command will allow you
to customize this behaviour:

```bash
# remove the Welcome banner upon viper startup:
$ charm welcome remove
# Later, restore this previous behavour:
$ charm welcome restore
```

## charm package



