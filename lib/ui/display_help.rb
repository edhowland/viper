# display_help.rb - say Help text

@hbuffer = ReadOnlyBuffer.new <<EOD
VIPER - Audible editor
Version #{Viper::VERSION}

Control Character Commands
-
Ctrl-Q: Quit editing
Ctrl-H: Display this Help Text
Ctrl-Y: Speak the name of the current buffer
Ctrl-S: Save the current buffer
Esc+ZZ: Write (save) the current buffer and exit the editor.
Shift+Home: Move to the beginning of the line
Shift+End: Move to the end of the line
Shift+PgUp: Move to the top of the buffer
Shift+PgDn: Move to the bottom of the buffer
Ctrl-J: Display the character under or to the right of the cursor
Ctrl-K: Display the current column
Ctrl-L: Display the current line
Ctrl-O: Opens a new line below the current line

Searching
-
Ctrl-F: Enter text to be searched forward for. 
Ctrl-R: Enter text to be searched backward for. 
Ctrl-G: Continue searching in the last direction

Ctrl-P: Display up to the next 10 lines of the buffer

Cut, Copy and Paste Commands
-
Shift+Right: Highlight and move right one character
Shift+Left: Highlight and move left one character
Fn4: Set/Unset mark to begin/stop highlighting text
Ctrl-C: Copy highlighted text to clipboard
Ctrl-X: Cut highlighted text to clipboard
Ctrl-V: Paste clipboard text into current buffer at cursor
 Undo/Redo
-
Ctrl-Z: Undo the last action
Ctrl-U: Redo the last action undone (from last Ctrl-Z)

Multi-deletion commands
Option/Alt+D: Starts Meta commands
d: Delete current line
shift_home: Delete to front of line
shift_end: Delete to end of line
shift_pgup: Delete to top of buffer
shift_pgdn: Delete to bottom of buffer
Commands
-
Ctrl-D: Enter editor debug mode (pry session). Ctrl-d again to return to editor session

Function Keys
-
Snippet Commands
F1: Start recording snippet named for characters to left of cursor
  Press Ctrl-S to save snippet
  Press F1 again to return to current buffer
F2: Playback snippet named for characters to left of cursor

Command Entry
-
Meta+; enters command mode.
Available commands are:
w  - writes (saves) the current buffer
w filename  - writes the current buffer to a file in filename. Does not change the current buffer/file.
q  - Exits the current editor loop.
q!  - Exits the editor without saving any unsaved changes.
wq  - Writes and saves the current buffer and exits the editor.
rew!  - Re-reads the current file into the current buffer, overwriting the contents, if changed.
r filename  - reads the contents of the filename into the current buffer at the current cursor position.
EOD


@hbuffer.name = 'Help Buffer'
