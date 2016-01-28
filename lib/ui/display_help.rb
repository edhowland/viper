# display_help.rb - say Help text

def help_buffer
  hbuffer = ReadOnlyBuffer.new <<EOD
VIPER - Audible editor
Version #{Viper::VERSION}

Control Character Commands
-
Ctrl-Q: Quit editing
Ctrl-Y: Yanks a line into the clipboard
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
:yank  - Yanks one line into the clipboard (preceed with Command meta key)
Undo/Redo
-
Ctrl-Z: Undo the last action
Ctrl-U: Redo the last action undone (from last Ctrl-Z)

Del: Deletes the character under the cursor
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

Command Entry
-
Meta+; enters command mode.
Available commands are:

Buffer commands
-
w  - writes (saves) the current buffer
w filename  - writes the current buffer to a file in filename. Does not change the current buffer/file.
s  - Save As. Saves the current  buffer as a new file name.
q  - Exits the current editor loop.
q!  - Exits the editor without saving any unsaved changes.
wq  - Writes and saves the current buffer and exits the editor.
rew!  - Re-reads the current file into the current buffer, overwriting the contents, if changed.
r filename  - reads the contents of the filename into the current buffer at the current cursor position.
g <line> - Goto a specific line in the current buffer
goto position - Jumps to specific position (offset from beginning of buffer).
o filename - open a new file
k! - Kill (delete) the current buffer
n - Rotate to the next buffer
p - Rotate to the previous buffer
new -Opens a new scratch buffer
yank - Yanks the current line into the current clipboard.

Reporting commands:
-
report - Speaks the name of the current buffer, its position and associated snippet collection.

System calls
check - Checks Ruby syntax of current buffer
lint - Little Linter: Use Rubocop. 3-Pass lint checker
load_cov path_to_coverage.json - Loads JSON report from simplecov
cov - Coverage report of file in current buffer

Snippet commands
-
slist - List loaded snippet collections
list collection - List available snippets in collection.
load file collection - Loads a file.json into a snippet collection. E.g. "load ruby ruby"
assocx pattern collection - Associates the extension pattern with the collection. E.g. assocx .rb ruby
assocf pattern collection - Associates the file pattern with collection. E.g. assocf /.+_spec\.rb/ spec
assocd pattern collection - Associates the Directory pattern with the collection. E.g. assocd /home/edh/src default
  To use a Regex with assocd, use %r{} syntax. E.g. assocd %r{/path/to/.*/spec/} spec
apply snip collection - Applies the snippet named snip from collection into current buffer. E.g. "apply def ruby"
snip name collection - Creates a new snippet named name (or overwrites one) from the current buffer into the collection. E.g. "snip def ruby"
  - Note: Use with new command to create a scratch buffer
    You can kill the scratch buffer with k! command.
sedit snip collection - Edits the named snip from the collection into the current buffer.
  Warning: This will first clear the contents of the current buffer.
  Use :new first to create a new scratch buffer.
  When done, use :snip name collection to save it.
dump file collection - Dumps the collection into file file.json. E.g. "dump ruby ruby"

Help Commands
help - Displays this help
EOD

  hbuffer.name = 'Help Buffer'
  hbuffer
end
