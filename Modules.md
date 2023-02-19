# Vish modules

## Abstract

A Vish module is just some functionality that can be imported. It is
no more than a directory of Vish source files that can be searched in a module
search path. Filenames inside the module
subdirectory also obey a file naming scheme. And, finally, there is
a file in that directory called on_import.vsh. More on that below.


## Modules and packages

Why are there two library conventions in Vish: Modules and Packages?
A package is a conceptually higher order abstraction than a module.
That said, a module has more moving parts than a package which just
is a searchable file of Vish sorce code.
Maybe a package is a conductor of an orchestra of one or more modules and even solo source files.

Anyway, a package can refer to, and contain one or more  modules
but also a module could load a package. so, there is that.

Read more about packages here: [Packages.md](Packages.md)
You might also be interested in plugins, a kind of package: [Plugins.md](Plugins.md)


## The module search path ':mpath' variable


The :mpath string is a ':' delimited set of full paths to parent directories
that might or not contain any module directories.
You can see the current :mpath variable with thethese two methods:

```bash
$ charm status
# ... Section for modules
$ vish -e 'echo :mpath'
/home/edh/tmp/viper/local/packages/vip.d/modules:/home/edh/tmp/viper/local/viper/modules:/home/edh/tmp/viper/local/vish/modules
```

Or, do the same in the Vish REPL: ivsh, or invoke Command mode
in Viper by Alt plus semicolon and enter: 'echo :mpath' and press Enter.
You can see what modules Vish knows to how to find with the charm program:

```bash
$ charm module ls
```

Note that this last approach does not find modules known only to specific packages.
But there is a way to get at those. See the next section.
But, first, we must mention a way to set your own :mpath search path.

There are two ways to accomplish this:

1. Use keyword arguments to the import command
2. Use the MPATH shell environment when invoking any program in the Viper ecosystem.

### Use the mpath keyword argument before invoking the import command

A typical example might be use of an embedded set of modules inside a package.
Inside a package created with the 'charm package new <package_name>'
is a variable called ':pdir' that is the full pathname to the associated
<package_name.d> directory. By appending the string: '/modules'
to :pdir, you can import any module find therein.

```
rem some Vish source in mypackage_pkg.vsh
mpath=":{pdir}/modules" import foobar
```


The above code will fool the import command to only look inside: <lpath_component>/mypackage.d/modules
for the module called foobar in mypackage.d/modules/foobar.


## Use of the shell environment $MPATH variable

Setting MPATH=<path_to_some_folder> before invoking any Viper
command, will prepend that full directory to the actual :mpath upon Vish
startup.

For instance, we can see what packages exist and then query them for their packages

```bash
$ charm package ls

Known packages to Vish and Viper
Packages in /home/edh/.config/vish/packages
Packages in /home/edh/.config/vish/plugins
python_lang
Packages in /home/edh/tmp/viper/local/packages
charm
repl
vip
viper
vish
Packages in /home/edh/tmp/viper/local/plugins
ruby_lang
vish_lang
```

We can see the 'charm' package itself. Let's check its possible modules

We need to know the value of the location of an individual package first.

We can get that by 

looking at this message:


```
Packages in /home/me/tmp/viper/local/packages
```


```bash
$ MPATH=/home/me/tmp/viper/local/packages/charm.d/modules charm module ls
Known modules located in mpath
/home/me/tmp/viper/local/packages/charm.d/modules :
charmutils
```




## Structure of a module directory

### The Vish source filename convention


Source files inside the top level of a module directory should follow this name convention:

999_filename.vsh

where the 999 part should be a zero padded mumerical sequence.

```bash
$ cd "$(vish -e 'echo :lhome')/plugins/ruby_lang.d
$ ls modules/syntax
001_checkrb.vsh
002_settings.vsh
003_macros.vsh
```



When the ruby_lang package does an :

```
import syntax
```

Each of these above 3 files are sourced in sequence.

### The (possible) existance of  the modulename/on_import.vsh file

If this file exists in themodule , it will be sourced after all the
existing  sequenced filenames have been sourced.
In this manner, importing a module can actually perform some action making
it a fully autonomous command. A bit like just running 'source codefile.vsh'
but getting the full benefit of  sourcing all the files therein.

### No limit to how many other files can exist inside a module directory


Data files, documentation and even other  modules or packages can exist
inside a module directory.

All source files beginning with 999_X.vsh or on_import.vsh
have the builtin variable: ':__DIR__'
which is the full path to this module and can be combined with other
directories or filenames for any purpose.



## The module search path inside of a package

Again, by way of convention, packages locate their own  internal modules with:

package_name.d/modules/module_name/

Let's create our own package and  populate with a new module

```bash
$ charm  package new mypack
Creating new package source directory in mypack/
Which will become a git repository
Initialized empty Git repository in /home/edh/charm/mypack/.git/
$  cd mypack/
$  charm module new myutils
sample templates copied into mypack.d/modules/myutils
$  
```


After this operation, mypack/mypack.d/modules/myutils will contain 2 files

1. 001_sample.vsh : A file of Vish comments onlyy
2. on_import.vsh : Another file of comments

You are free to rename/remove these files at will.

They are not added to the git repository yet. That is your job.

## Creating a standalone module


```bash
$ charm module new singmod
```

This creates a directory: singmod/ with the above files 001_sample.vsh and on_import.vsh

## Testing your module after you add code.


As stated above, the MPATH shell environment variable can be set temporarily
to allow for testing any module.

If in a package, then you can either do:

- Test the entire package with the LPATH shell variable. See [Packages.md](Packages.md)
- Set MPATH to ${PWD}/mypack.d/modules

But that might be risky.

### Testing standalone modules

All 4 Viper executables understand the MPATH shell environment variable.

This includes:

- viper
- vish
- ivsh
- charm

If your module contains variables, functions and aliases,
then try out ivsh, the Vish REPL, first.

```bash
$ MPATH=${PWD} ivsh
vish> import singmod
vish> .... test out things now
```

Caution: Be aware of what the file 'on_import.vsh' might doif it is present.



##  Other uses of the charm module subcommand

### ls

```bash
charm module ls
```

will list the  current modules found in the :mpath search path

to get even more modules, say within a package, prepend the MPATH variable first:

```bash
MPATH=/path/to/package/package.d/modules charm module ls
```

You can use the 'vish' command to help you with this task. 

```bash
# Say we only want to search the first component of :lpath for our modules
$ MPATH="$(vish -e 'echo :(ifs=: first :mpath))/mypack.d/modules" charm module ls
```


###  package

This package helps you out finding known modules if you know the name of the
of the package the modules might be listed in. It is similar the the MPATH=
wexample where we looked at the first component of :lpath above.

Say you want to see the modules for the Ruby language plugin:

```bash
$ charm module package ruby_lang
modules in ruby_lang package of lpath component /home/me/tmp/viper/local/plugins
syntax
```

The package must exist some where in :lpath.
But you can prepend more paths with the LPATH= method, as previously mentioned.

### help

This subcommand lists information about the charm module command, including explantions
regarding its subcommands.

```bash
$ charm module help
```

## Conclusion

A Vish module is just a directory of Vish source code that can be gulped
in one stroke with the import <module_name> command. You can use the charm program
to  query and create  new modules.
Modules can be stand-alone or part of a Vish package.
Filenames in a module subdirectory obey a naming convention that is sequential.
And a file called: 'on_import.vsh', if it exists in the module subdirectory,
will be sourced after all other sequentially named source file have been sourced.

Fundamentally, a module is just a searchable bundle of Vish functionality with a name
that be imported with: 'import module_name'.
