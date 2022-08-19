# Command keys for the Viper editor

## Non-printable keys

- Enter or Return: Adds a newline at the current  cursor.
- Space: Enters a space character at the current cursor.
- Tab: Enters the current number of space characters according to the current indent type.
- Shift+Tab: Performs a BackTab, or deleted the number of characters to the left of the cursor, according to the current indent type.
- Backspace: Deletes one character to the left of the cursor.
- Delete: Deletes one character under the cursor., moving subsequent characters to the left.
- Shift+End: Moves the cursor to the end of the line.
- Shift+Home: Moves the cursor to the beginning of the line.
- PgUp: Moves the cursor to start of the buffer
- PgDn: Moves the cursor to end of the buffer.
- Left, Up, Right and Down arrow keys: Moves the cursor one position to the: left, up one line, right and down one line.

## Function keys

- F1:  Speaks the number of open buffers
- F2: Speaks the name of the current buffer. Probably its file name. If the  buffer is modified and not saved, it will have a trailing '*' after itsname.
F3: Prompts for you to press some key. Speaks the action of that key.
- F4: Sets a standard mark. All cursor movements after that will select that text.

## Control keys

- ctrl_a: Selects the entire buffer
- ctrl_c: Copies the selection into the clipboard
- ctrl_e: Evaluates the content of the current buffer in the Vish language. See the file Vish.md
- ctrl_f: Enter search forward mode. Waits for regex search term followed by newline.
- ctrl_g: Repeats the last search in the last search direction.
- ctrl_i: Inserts spaces
- ctrl_j: Speaks the character under the cursor
- ctrl_k: Speaks the current column position
- ctrl_l: Speaks the entire current line



## Meta keys

Meta keys can be pressed by holding the 'Alt' key and the key listed below.

- meta_a: Speaks and moves the current line and the next 10 lines. The cursor ends up on the first column of the 11th line after the current line.
- meta_d: Starts delete mode. The next character pressed must be one of the folloing.
  * c: Clears the current line, leaving the linefeed in place
  * d: Deletes the current line
  * h: Deletes to front of line
  * j: Delete to bottom of buffer
  * k: Deletes to top of buffer
  * l: Deletes to end of line
  * w: Deletes word forward
- meta_f: Moves to the next tab point
- meta_j: Speaks the current word under the cursor.
- meta_k: Speaks the current indent level.
- meta_l: Speaks the current line number.
- meta_m: Waits for a letter and sets a mard with that name.
- meta_n: Insert a character before the current cursor. Like move left 1 position and insert.
- meta_p: Speaks the current cursor position.
- meta_w: Moves one word back
- meta_z: Redoes the last undone action
- meta_';': Pressing 'Alt'+';' will open  command mode. Any single line Vish command can be entered here. E.g. 'o filename' will open  filename in a new buffer and switch to that buffer.

