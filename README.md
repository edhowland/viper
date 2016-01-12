# VIPER

## Visually Impaired Programmer's Editor in Ruby

### Version 0.8.1

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
- Option/Alt+; help - Brings up Help text

## Features:


Snippets - Ability to record and playback short snippets of commonly used texts.
Copy and Paste: Limited Shift+right, left arrows to select text and Ctrl-C, X and V to Coy, Cut and Paste.
Search and Reverse Search. (Ctrl-F. Ctrl-R).
Ctrl-G to continue searching in the last direction of the last search.
  Since the search enter area is another buffer, can use regular editor commands within it. E.g. Ctrl-V to paste in some 
  text to be search to be for.
Also, up and down arrows work like in Bash readline to recover the last thing you searched for.
Undo/Redo: Ctrl-Z and Ctrl-U will undo the last editor action, and replay them uf needed.

Ctrl-A: Selects the entire buffer.
Fn4: Sets/Unsets a mark. Cursor movements from there selects and highlights text.
The Meta key is Alt or Option depending on your keyboard layout.
Meta+D - Starts a Delete sequence:
+ 'd' - Deletes the current line.
+ Shift+Home - Deletes to the front of the current line.
+ Shift+End - Deletes to end of the current line.
+ Shift+PgUp - Deletes to the top of the buffer.
+ Shift+PgDn - Deletes to the bottom of the buffer.
Debug mode: For debugging the editor itself.
  Ctrl-D enters pry, where you can look around. Ctrl-D again to return to editor loop.


## Command Entry


Option/Alt+';' enters command mode where you can run some some editor functions.
These are very vim-like in form and syntax.
E.g.  w filename - writes the current buffer to filename. rew! re-reads the current file back
into the current buffer, overwriting any changes.


## Help


Meta help brings up a help buffer. You can
return to the previous buffer with either Ctrl-T or meta+n, meta+p to rotate through buffers.


