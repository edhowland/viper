charm package is the command that helps create and maintain packages in the Viper
and Vish ecosystem.

charm package has the following sub commands

charm package ls : Lists installed packages
  Each package can be loaded with the "load package" Vish statement.
charm package new : Creates a new package project and populates from templates.
charm package test <test_file.vsh> : Establishes current package directory for testing.
  Sets up :lpath so that test_file.vsh can "load package" this package in this directory for testing.
charm package install <source> <destination> : Copies source folder contents to destination folder 
  Both arguments must be a directory. You can invoke this command many
times because if the package has been previously installed it will be
uninstalled first.
charm package uninstall <package> : Uninstalls the requested package
If the package has a package dir with the name 'package.d/' it will also
be recursively removed.
charm package help : Displays this page.
Note: Since Vish plugins are just packages under another name, using :
charm package install ~/.config/vish/plugins is how you install plugins.
