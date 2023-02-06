The charm module command can list known modules that can be imported with
'import module' command in Vish scripts or interactively.

The module search path that import uses is defined in the mpath variable.

To list the current known  modules in all components of mpath issue the following command

charm module ls

Note: mpath starts out with modules available only in the global environment.
If inside a loaded package, mpath may differ probably by being prepended with
the package's module search path.
To see these modules, you have to manually supply the mpath variable before issuing the
charm module command


E.g. To see the modules listed for the the charm command itself:

MPATH=~/src/viper/local/packages/charm.d/modules charm module ls


Note here above, the MPATH is all uppercase.
The Viper and Vish programs are assumed to exist in ~/src/viper/ for this example

To see which packages are installed, issue the following command
charm package ls
This will list every known package found in the 'lpath' package search path.


Note that not every package defines its own mpath module search path. For the
ones that do they will usually follow this pathname convention:

<lpath.component>/<package>.d/modules

E.g. append the package.d/modules string onto the lpath component.


## charm module new

The new subcommand will create a new module subdirectory and populate with sample template files.

### Usage

```bash
charm module new module_name
```

If you are currently a package source lair, then the charm package new
will place the new module inside 'package_name.d/modules'. Otherwise, it will just
create a new subdirectory under the current directory named for the module_name.
