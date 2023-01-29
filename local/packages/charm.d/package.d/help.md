charm package is the command that helps create and maintain packages in the Viper
and Vish ecosystem.

charm package has the following subcommands

charm package ls : Lists installed packages
  Each package can be loaded with the "load package" Vish statement.
charm package new : Creates a new package project and populates from templates.
  Also initializes and empty git repository if git is installed.
charm package test <test_file.vsh> : Establishes current package directory for testing.
  Sets up :lpath so that test_file.vsh can "load package" this package in this directory for testing.
charm package install <path> : Copies this directory's contents to ~/.config/vish/packages/<package_name> or <path>
  Useful if you have cloned this repository and want to  use it for Viper or Vish projects.
charm package help : Displays this page.
Note: Since Vish plugins are just packages under another name, using :
charm package install ~/.config/vish/plugins is how you install plugins.
