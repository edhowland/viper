# Current show stoppers

## charm package install is broken

- should work immediately after 'charm package new <pkg_name>'
- Must supply exactly 2 args: source, dest
- Will try to clean up <pkg_name>.d folders before copying



## after starting  ivsh cannot  load viper_help


And any  call to help after viper is running results in the following error:

```vish

vish >help buffer
undefined local variable or method `parse_md' for #<Mdparse:0x0000000104ca0dc8 @options={}>

    parser = parse_md
             ^^^^^^^^
Did you mean?  parser
exitting Vish
```


Looking at the source it requires the redcarpet gem, which is commented out in the GemFile.
Vish functions help, help_qlaunch and help_parse eventually resolve to:
/v/bin/mdparse which when given a string like doc or help, results in the above Ruby error





## The entire help subsystem must be overhauled

- Legacy code mixed in with code once charm subsystem was created
- Completely remove any whiff of the man command
  * Unneeded as Nushell has proven
- Remove mdparse
  * Requires the redcarpet gem
  * Must be made to  just print out the contents of the raw help_topic.md file


### Questions to be asked about help?

1. Should help be its own package?
  * There are already vish_help and viper_help
  * These packages make various help topics available to overall help system
2. Minimal help
  At the very least help should have some pre-loaded content, probably about its ownself and possibly vish_help ???

#### Remove the help function from ./local/viper/modules/edit/*_help.vsh

Add a new package via  the ./charm package new help_help
to test out this 

Rebuild from there.


## The 'vm' alias is:


# The following might habe been made moot by 2.0.14.x

```
alias vm='TERM_PROGRAM=xterm viper'
```

Note the  requirement to  specify TERM_PROGRAM to be xterm because only Apple MacOS
sets this. so, things like the alias for mx.create does not know to do this because it is just: 'viper'.
And cannot embed it in the $EDITOR variable.



Temporary fix:

in ~/mail/.functions: mx.create:

replace $EDITOR line with the line:

```bash
if [ -z "$TERM_PROGRAM" ]
then
  # Normal  OSes like Linux
  # original $EDITOR ... line
else
  # correct for the  apple macos problem
  TERM_PROGRAM=xterm $EDITOR  ...
fi
```


## Should not hard exit out of viper if typed 'exit' in the inner REPL

Currently if you type  'exit' either in the command prompt or in 'vish' after the command prompt,
it hard exits w/o asking to save any unsaved buffers.
This was probably an intentional decision for the developers working on viper itself.
Probably need to catch/rescue the inner Exit... exception. in this case but not in normal vish programs.
This can be done via a catch in vish and the whole can be aliased to the 'exit' command.


##### Fixed

- from charm package new is boinkers
- Should NOT add a .git directory if one already exists in some  current or heigher level dir
