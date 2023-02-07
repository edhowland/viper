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



You can check if this directory structure is known to the Vish  by invoking:

```bash
charm status
```


## charm config vishrc

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
then charm config project will also invoke the 'charm ignore' command which
will place ./.vishrc in your .gitignore file. See charm ignore help for details.
If you have either set no_use_git=true in any of   your .vishrc files, it will not
perform this action.



## charm config path

This subcommand 'path' will construct a PATH shell environment variable
that 

## charm config help

Displays this message.
