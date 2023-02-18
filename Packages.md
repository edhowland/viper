# Vish packaging

## Abstract

Vish is the Viper shell extension language. In fact Viper is just a Vish
program. As a matter of fact, viper is really a Vish package. It can be loaded
like any other Vish package.

### Vish packages are really at their heart just a Vish source file

The only real difference between any other Vish source anda Vish formal package
is the naming convention used for package filenames and their location
within a package search path.


## The load command

In Vish code, the load command is used to load a given package by name.

E.g.

```bash
$ ivsh
vish> load viper
```

After the previous command has been executed in the Vish REPL above, all of
the editor commands and functions are available to the REPL.

### The :lpath search variable used by the load command

When Vish starts up it is pre-loaded with a package search path. This is stored in the :lpath
variable.

```
vish> echo :lpath
/home/me/.config/vish/packages:/home/me/.config/vish/plugins:/home/me/src/viper/local/packages:/home/me/src/viper/local/plugins
```

Note each directory is delimited witha ':' . 

This $HOME/.config/vish/{packages,plugins} will only exist if you have
previously run the charm config create command. See [Charm.md](Charm.md)
However, the /home/me/src/viper/local/{packages,plugins} is an example of the
kind of location where the user: 'me' might have cloned the viper repository
locally.


### Note about plugins

In Vish plugins are just packages under another name. The only difference is the
:lpath search path convention. E.g. plugins/ instead of packages/.

See more information about plugins here: [Plugins.md](Plugins.md)

## The package source filename convention

Once load gets underway looking for your package, it expands the packagename
into the following:

- mypackage => mypackage_pkg.vsh

In other words, it just appends "_pkg.vsh" to  the package name.
The final result is a component of the :lpath search path prepended
to the front of the package name and the '_pkg.vsh' appended to the back of the string.
Then, given this fully qualified pathname,  it just sources this pathname.


## No mystery here.

That's it. All a package is just a Vish source file named a certain
way and placed somewhere in a component of the :lpath search directories.


### The LPATH environment variable and how it can be used to modify Vish's :lpath

When starting any Vish program like viper, vish or ivsh and even charm,
you can prepend an unknown (to vish) directory  to the :lpath search path.

E.g.

```bash
ls *_pkg.vsh
mypackage_pkg.vsh
$ LPATH=${PWD} ivsh
vish> load mypackage
```

This helps with testing new packages under development.

## Another naming convention: The package_name.d subdirectory

This part is really optional. But some packages might want
to contain other files  This convention (package_name.d) ensures that
any other packages that live in the same component of the :lpath search variable
will not conflict with each other.

## Modules internal to a package

Another convention is to place any modules that a package might use in a subdirectory
called: package_name.d/modules. E.g. They  language support plugins have the 
this structure:

```
python_lng.d/modules/syntax
```

The :mpath variable is prepeneded with ~/.config/vish/plugins/python_lang.d/modules
Then in ~/.config/vish/plugins/python_lang_pkg.vsh you can do:

```
import syntax
```


- For more on modules see [Modules.md](Modules.md)
- For more on plugins see [Plugins.md](Plugins.md)





## Capabilities of packages
