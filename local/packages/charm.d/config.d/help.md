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

```bash
charm status
```


### HOME/.config/vish/rc

This file is supplied from a template and is the Vish init file like ./.vishrc
It can contain any valid Vish settings, variables, aliases and functions, which
will override the default settings, et al of Vish.

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
