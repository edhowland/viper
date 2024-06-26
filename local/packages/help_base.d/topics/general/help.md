# Help for Help

This is the basics of the help subsystem for Vish and all the projects
in the Vish ecosystem such as the Viper editor.

## Invoking help

From anything like the REPL (ivsh) or the command shell in the Viper editor
you can always type:

```sh
help cat
```

where cat is the topic  you want help for (in this case the 'cat' command.)


The help subsystem  is also available as a package that can be loaded in other Vish scripts.
One such place might be the 'charm' program itself.

```sh
rem  Load the base part of the help subsystem
load help_base
```

where 'help_base' is this package.

## See also

```sh
help help_command ; rem  specifics about the help command itself
apropos <search string>   ; rem searches for help topics that mention search string
category all    ; rem lists all the currently loaded categories of help topics
category <category>  ; Shows the index.md of that category
```


## 

