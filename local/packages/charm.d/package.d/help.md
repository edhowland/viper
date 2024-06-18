charm package is the command that helps create and maintain packages in the Viper
and Vish ecosystem.

charm package has the following subcommands

charm package ls : Lists installed packages
  Each package can be loaded with the "load package" Vish statement.
charm package new : Creates a new package project and populates from templates.
charm package test <test_file.vsh> : Establishes current package directory for testing.
  Sets up :lpath so that test_file.vsh can "load package" this package in this directory for testing.
charm package install <source> <destination> : Copies source folder contents to destination folder 
  Both arguments must be a directory. You can invoke this command many
times while developing a package or plugin, the contents will be overwritten.
  The contents of the <pkg_name>.d will be removed first so as not to cause  problems with left over files/dirs.
charm package help : Displays this page.
Note: Since Vish plugins are just packages under another name, using :
charm package install ~/.config/vish/plugins is how you install plugins.
