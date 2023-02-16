# Viper language plugins

## Abstract

A language plugin for the Viper code editor is just a Vish package. It lives,
however, in the 2 possible plugins directories.

- ~/.config/vish/plugins : If this directory structure ~/.config/vish has been created
  * It can be created and populated with the command: 'charm config create'
- :lhome/plugins : Where :lhome is the source location of the Viper source directory/local
  * This directory is where you probably cloned your viper repository

## Layout of an example plugin package

Let's try and create a plugin for the Python programming language.
We will call this plugin: python_lang. It will be aware of the .py filename extension.
We assume that this machine has git installed so it will be used in the examples below.

```bash
$  charm package new python_lang
Creating new package source directory in python_lang/
Which will become a git repository
Initialized empty Git repository in /home/me/dev/vish_plugins/python_lang/.git/
$  ls -1R python_lang/
python_lang/:
python_lang.d
python_lang_pkg.vsh

python_lang/python_lang.d:
modules

python_lang/python_lang.d/modules:
```

After running running 'charm package new package_name', the directory is created
and made into  a git repository. It then creates a file called: 'python_lang_pkg.vsh'
This is  where all the magic happens.  More on this file in a bit.

Notice also that a two level directory 'python_lang.d/modules' has also been
created for us. The 'python_lang.d' directory is where any files or other directories
that we might need later reside. For now, there is only the modules directory
and it is empty. In a few, we will be adding more content therein.


## Create a module that the plugin package can store its functions and settings

Here we will use the 'charm module new module_name' command to do the heavy
lifting for us. The 'module new' command is aready aware that it is in
an existing package.

```bash
$ cd python_lang/
$ charm module new syntax
sample templates copied into python_lang.d/modules/syntax
$  ls -1R python_lang.d/modules/
python_lang.d/modules/:
syntax

python_lang.d/modules/syntax:
001_sample.vsh
on_import.vsh
```



## Rename the sample scripts that have been created from templates

Let's turn our 001_sample.vsh into our Python syntax checker funtion.
This should become a function that should be named: 'checkpy'
When a buffer containing a filename with a '.py' extension has been detected,
the normal check command  will be set to point at this 'checkpy' function.

```bash
$   cd python_lang.d/modules/syntax/
$  mv 001_sample.vsh  001_checkpy.vsh
```

Now we should  edit this file and add the following code:

```
rem checkpy.vsh fn checkpy cats buf into python syntax checker
function checkpy() {
   cat < :_buf | sh - "py -c 'import sys; import ast; ast.parse(sys.stdin.read())'" && echo Syntax ok
}
```



This function in syntax/001_checkpy.vsh will be called whenever 2 things are true:

1. The current buffer has a filename extension of '.py'
2. The user has entered the Vish command 'check'

The contents of the current buffer (which the :_buf variable is set to)
is concatenated to the shell command that will call the the python executable
and pass it an inline Python script to execute with the '-c' option.


Note: This example is a bit obtuse because Python does not have a very simple
command line option to  simply check the syntax of of a script or standard input
and return a 0 exit code if it passes, else report the source of the errors
and return a non-zero exit code.

For instance here is the same code for checking Ruby code:

### syntax/001_checkrb.vsh:

rem checkrb syntax checker for Ruby language .rb files
function checkrb() { cat < :_buf | sh - ruby -c }
```


This works because 'ruby -c' takes in stdin and if it isvalid Ruby syntax, it reports
'Syntax Ok'.

There is also a similar function: 'checkvsh' that works with .vsh extension files.
However, because we are inside Vish itself, there is no need to shell
out to another program.

## Create a setting file: 002_settings.vsh in ./this syntax directory

```
rem settings.vsh settings for the Python language
set_ext_fn py &() { checker=checkpy autoindent=true indent=4; global checker autoindent indent }
```

This lambda function will be executed whenever a file with the .py extension
is detected as the filename in the current buffer.

Note that the lambda will set the following items for us and make them global:

- checker: Will be set to be the new function: 'checkpy' we created above
- autoindent : A variable set to true that will autoindent our code when we are
- indent : The number of spaces to for autoindent, when the tab or backtab key is pressed.
indented

## Remove the syntax/on_import.vsh file

The  file on_import.vsh in the syntax module is just a couple of comments
and can be safely removed.

```bash
rm python_lang.d/modules/syntax/on_import.vsh
```

## Integrate the module with the python_lang package

```bash
$ viper python_lang_pkg.vsh
```

The code should look something like this:

```
rem package python created from charm package new
pdir=":{__DIR__}/python.d"
mpath=":{pdir}/modules::{mpath}"
mkdir /v/known_extensions/py
import syntax
```

There is 2 things to note above:

1. We need to register the directory: /v/known_extensions/py for the '.py' filename extension
2. Once that exists, we can safely import the syntax module we just finished constructing

## Testing

Currently, the python_lang plugin (which is just a a package anyway) is not known to Vish
and also not known to Viper. In a minute, we will install it permanently.
But for now, we can test it with by invoking Viper and giving the LPATH
environment path to our source directory:

First we need to perform a small trick to get the plugin subsystem to be
able to automatically locate our new plugin for us:

```bash
$ pwd
/home/me/dev/rust_lang
$ ln -s ${PWD} /home/edh/dev/plugins
```


This symlink fakes out our plugin finder to search also in this directory.

Now start up a Viper editing session prefixing it with the LPATH environment variable:

```bash
LPATH=/home/me/dev/plugins viper foo.py
```



To check if this works

Invoke command mode by Alt plus semicolon and tye vish and press Return.
In the vish REPL:

```
echo :checker
checkpy
echo :autoindent
true
echo :indent
4
```


Now press Control plus d to return the editor and type in some Python code and
see if it syntax checks.

## Note on macros

Macros for the Python language are not covered here. But here is a guide to


1.  create a new directory: python_lang.d/macros
2. (This is where a JSON file  : python.json containing the various macros will live when it is created)
3. Create a new file: python_lang.d/modules/syntax003_macros.vsh

It should have the following code:

placing in the python_lang plugin:

rem macros.vsh macros for Python language
json -r /v/macros/.py < ":{pdir}/macros/python.json"
```


When the plugin package is loaded,  the JSON file  will be parsed and expanded into: /v/macros/.py

See the Macros documentation for further help on writing and testing macros in Viper.

## Final step: Install the Python plugin

### Do not forget to save your work  by commiting to your git repository:

```bash
$ pwd
/home/me/dev/python_lang
$ git add .; git commit
```

Now we can safely install our  package in ~/.config/vish/plugins and it will be
found by Viper's plugin subsystem:

```bash
$ pwd
/home/me/dev/python_lang
$ charm package install ~/.config/vish/plugins
The current package python_lang will be installed in /home/edh/.config/vish/plugins
```


This command: 'charm package install <path>' will copy thi e



That's it! Now you can go anywhere and edit Python code with
the ability to autoindent and check the syntax of your code.



## Future directions

Soon, there will be a couple of new charm commands:

- charm package search <package search term>
- charm package get <package_name>
- charm package tarball <package_path>
  * The package_path should be where the git repository exists
- charm package remove <package_name>


This Vish package infrastructure has yet to be completed, but when it is,
you will be able to search for packages and download them, test them and install them.

The overriding goal of the Vish package infrastructure is to keep it as simple
as possible. Simple for users to create for themselves.
Simple for package authors to share their creations with others.

In that regard,  this matches with Vish's philosophy: Use what you already know:


You already know how to use git and online resources like github.com.
You already know how to clone a new git repository. This is how you got here
when you installed Viper.
You already know how to submit a pull request.

The package infrastructure is simply a GitHub repository.
The list of existing packages, including language plugins,  is just a simple
text file that can be downloaded with curl.

The actual package is just a normal tarball that can also be downloaded with wget or curl
and then extracted.

All charm package does is to preformat the various URLs for you.

