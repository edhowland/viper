# Viper modes

## Abstract

A mode in Viper contains all the keybindings that are useful for that mode. E.g. in
delete mode, only a few keys are active like 'd', 'c', 'w', 'j', 'k' and 'l'

Viper operates in a single mode at any given time. Which mode is active depends on the
command or key press used in the current mode was used to activate it.

Viper starts up in viper mode which is the basic editor mode.

## List of all modes


- command
- delete
- help
- init
- ins_at
- macros
- mark
- prompt
- search
- undo
- viper (default)

## Modes are created via Vish scripts

All of the modes are created by the initialization scripts found in the scripts directory.



001_editor.vsh
002_viper.vsh
003_command.vsh
004_delete.vsh
005_search.vsh
006_prompt.vsh
008_marks.vsh
009_undo.vsh
010_macros.vsh
013_help.vsh
014_terminal.vsh
015_ins_at.vsh



Note: The above list is not comprehensive. There are currently exactly 15 initialization scripts.


## Views and klogs

A view is a code block associated with a key press.

A klog is a code block associated wih a key press.

TODO
