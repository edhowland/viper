The charm status command displays various properties of the Viper and Vish
ecosystem. This includes:

- Whether the Welcome banner is displayed when Viper starts with no files to edit
- Whether you have a config directory in ~/.config/vish
  * This directory becomes the first package search path if it exists
  * The charm package install command will place packages here by default
- Whether you have a ~/.vishrc file in your home directory
  * You can create a sample one with the command charm config vishrc
- Whether you have a local .vishrc in your current directory
  * You can create a sample ./.vishrc from a template with the command
  * charm config project
  * Any settings in this local .vishrc will override any settings in Vish/Viper
  * and any in your ~/.vishrc in your home directory
- The value of the :lpath variable the search path of Vish packages when the
  * load package is invoked
- The value of the :mpath module search path when used with the import module
  * command.
  * Note: Vish packages might include their own modules.
  * charm status only displays global :mpath variable, not the internal mpaths
  * of any packages. See charm module help for more details.
- Whether git is installed on your system
- The value of the :no_use_git variable which determines if:
  * charm config project will add it to your .gitignore
  * charm package new will initialize a new git repository in the newly
  * created project
- Whether your current directory is a git repository
  * If it is and you also have a local .vishrc file there, you can do the
  * command to see if the .gitignore contains ./.vishrc :
 


```bash
grep  .vishrc .gitignore
```

If it does not contain it it then run:

```bash
charm ignore
```

to add it.
