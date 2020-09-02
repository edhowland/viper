# Keys for Viper editor

The action keys for the Viper editor mode are listed below. They are grouped by
Printable keys, Control keys, Movement keys, Function keys, Alt keys, and delete keys.
Within each group, all items are sorted alphanumerically

Unbound keys are listed as : Unbound. 
Users are free to bind these to new actions. [binding keys help](bind)



## Printable characters

Any printable character will insert its value at the current cursor position in the current buffer.
The exception is after some othercontrol or alt character prompts for an additional character.
An example is F 3, ehich

## Control keys

- Control A  : Selects all text of current buffer
- Control B : Unbound
- Control C  :  Copy marked section
- Control D : Unbound
- Control E : Evaluates the contents of the current buffer in the Vish language and runs the commands therein.
- Control F : Search Forward. Enter search term and press enter.
- Control G : Search again in last search direction.
- Control H : Unbound
- Control I : (Tab) : Inserts :indent spaces. (Normally 2)
- Control J : Reports character under cursor.
- Control K : Reports current character position on current line.
- Control L : Speaks the contents of the current line.
- Control M : (Enter) Insertsnewline character.
- Control N : Opens new scratch buffer.
- Control O : Opens up a new line under the current line. 
- Control P : Unbound
- Control Q : Quits Viper editor. Asking to save any unsaved buffers.
- Control R : Search reverse. Enter search term and press Enter.
- Control S : Save current buffer.
- Control T : Switches to next buffer in buffer ring. Rotates around if at end of ring.
- Control U : Unbound
- Control V : Paste contents of clipboard at current position.
- Control w : Moves forward one word in buffer.
- Control X : Cuts marked section to clipboard.
- Control Y : Yanks or copies current line intoclipboard.
- Control Z : Undoes last action.

## Movement keys

- Left arrow : Moves cursor one character to front of buffer 
- Up arrow : Moves cursor to previous line
- Right arrow : Moves cursor one character position to end of buffer
- Down Arrow :  Moves cursor to next line
- Shift Home : Moves cursor to front of current line
- Shift End : Moves cursor to end of current line
- Shift Page Up : Moves cursor to absolute front of buffer
- Shift Page Down : Moves cursor to absolute end of buffer
- Tab : Inserts :indent spaces. Usually 2.
- Shift Tab : (Back tab) Deletes :indent characters back. Undoes tab action.
- Space : Inserts a single space character in current buffer.
- Backspace : Deletes 1 character backward.
- Delete : Deletes 1 character forward.
- Return, Enter : Inserts new line character at current cursor position.

## Function keys

Note: If your terminal emulator does send function keys to the application,
you can get the same effect by holding the Alt or meta key and pressing 1 through 0
which are mapped to F 1 through F ten.


- Fn 1 : Reports status of Viper editor with number of open buffers
- Fn 2 : Reports Name of current buffer and a star if it has any unsaved changes
- Fn 3 : Prompts for next key and reports its action. Key help.
- Fn 4 : Sets a mark at current cursor position
- Fn 5 : sets special mark t for use e in macro recording
- Fn 6 : Starts macro recording. Press Fn 6 again to stop macro recording.


## Alt keys


- Alt A :  Speaks next 10 lines of text in current buffer
- Alt B : Unbound
- Alt C : Unbound
- Alt D : Starts delete dialog. See Delete keys below
- Alt f : Moves cursor to next mark. (As saved in :_mark variable)
- Alt j : Speaks the current word forward. Does not move the cursor.
- Alt k : Speaks the current indent level of the current line.
- l : Speaks the current line number.
- m : Starts Set mark dialog. Next character typed will be the name of the mark. Mark will be set at current position.
- Alt n : Prompts for next key which will be inserted at current cursor position without moving crsor.
- Alt p : Speaks the current character position in current buffer.
- Alt r : Moves to previous set mark position. See Alt f.
- Alt w : Moves cursor one word back in current buffer. See Control w.
- Alt z : Redoes last undone action that happened with Control Z.
- Alt 1  : Reports status of Viper editor with number of open buffers
- Alt 2 : Reports Name of current buffer and a star if it has any unsaved changes
- Alt 3 : Prompts for next key and reports its action. Key help.
- Alt 4 :Sets a mark at current cursor position
- Alt 5 : Sets mark t at current cursor position.
- Alt 6 : Starts macro recording. Press Fn 6 again to stop macro recording.

## Delete keys

After typing Alt D, press these next keys to delete some region of the buffer

- c : Clears the contents of the current line
- d : Deletes the current line
- h : Deletes To front of current line
- j : Deletes to bottom of buffer
- k : Deletes to top of buffer
- l : Deletes to end of current line
- w :  Deletes word forward
- Shift Home : Deletes to front of current line
- Shift End : Deletes to end of current line
- Shift Page Up : Deletes to top of buffer
- Shift Page Down : Deletes to bottom of buffer
