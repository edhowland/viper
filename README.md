# VIPER

## Visually Impaired Programmer's Editor in Ruby

## Abstract

This is simple editor in Ruby that works with screen readers, esp. like VoiceOver 
in Mac OS/X.

## Usage:

./bin/viper file.rb


This executes the main editor loop. To exit, hit Ctrl-Q at ant time.

Use the following control characters for some actions:

Ctrl-S: Saves the contents of the buffer
Ctrl-J: Reads the current character under the cursor. (to the right of the cursor).
Ctrl-K: Reads the current column on the line.
Ctrl-L: Reads the current line.
Ctrl-Y: Speaks the name of the current buffer
Ctrl-P: Outputs the next (max 10) lines
Ctrl-A: Moves to the front of the line
Ctrl-E: Moves to the back of the line
Ctrl-T: Moves to the top of the buffer
Ctrl-B: Moves to bottom of the buffer
TAB: Inserts 2 spaces

F1: Enters Snippet recorder for snippet defined from front of line to cursor
F2: Implements the defined Snippetfrom the front of line to the cursor

(Snippets are stored in ./config/snippets.json)

Ctrl-d: Enters a debug session with pry. Press Ctrl-d to return the editor.
(The debug session is for debugging the editor)

### HELP

Ctrl-H: Displays most of this help.
Press Ctrl-H again to return to the editor.
