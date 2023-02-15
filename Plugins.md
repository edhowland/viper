# Viper language plugins

## Abstract

A language plugin for the Viper code editor is just a Vish package. It lives,
however, in the 2 possible plugins directories.

- ~/.config/vish/plugins : If this directory structure ~/.config/vish has been created
- :lhome/plugins : Where :lhome is the source location of the Viper source directory/local

## Layout of an example plugin package

Let's try and create a plugin for the Python programming language.

```bash
cd src_root # where src_root is where you want to place all  your plugin packages
charm package new python
ls -1R python/

thor   vish_plugins  ls -1R python/
python/:
python.d
python_pkg.vsh

python/python.d:
modules

python/python.d/modules:
```

## Create a module that the plugin package can store its functions and settings

```bash
cd python/python.d/modules
charm module new syntax
ls -1 syntax

001_sample.vsh
on_import.vsh
```

## Create a setting file: 002_settings.vsh in ./python.d/modules/syntax/:
```
rem settings.vsh settings for the Python language
set_ext_fn py &() { checker=checkpy autoindent=true indent=4; global checker autoindent indent }
```

This lambda function will be executed whenever a file with the .py extension
is tabbed into or is the current buffer.

