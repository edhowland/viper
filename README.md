# VIPER

## Visually Impaired Programmer's Editor in Ruby

## Abstract

This is simple editor in Ruby that works with screen readers, esp. like VoiceOver 
in Mac OS/X. 

## Usage:

```

./bin/viper file.rb

```

This executes the main editor loop. To exit, hit Ctrl-Q at ant time.

### Use the following control characters for some actions:

- Ctrl-S: Saves the current buffer.
- Ctrl-Q: Exits the main editor loop and asks to save the current buffer, if dirtyi
- Ctrl-H: Displays help text describing more actions

## Features:


Snippets - Ability to record and playback short snippets of commonly used texts.
Copy and Paste: Limited Shift+right, left arrows to select text and Ctrl-C, X and V to Coy, Cut and Paste.
  Use Fn_4 to set/unset a mark position to begin/stop highlighting text.
  Any cursor movements selects text starting from the last mark set.
  Includes: beginning/end of line/buffer.
Search and Reverse Search. (Ctrl-F. Ctrl-R).
  Since the search enter area is another buffer, can use regular editor commands within it. E.g. Ctrl-V to paste in some 
  text to be search to be for.
Undo/Redo: Ctrl-Z and Ctrl-U will undo the last editor action, and replay them uf needed.
Debug mode: For debugging the editor itself.
  Ctrl-D enters pry, where you can look around. Ctrl-D again to return to editor loop.


