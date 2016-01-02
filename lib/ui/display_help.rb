# display_help.rb - say Help text

@hbuffer = ReadOnlyBuffer.new <<EOD
Control Character Commands

Ctrl-Q: Quit editing
Ctrl-H: Display this Help Text
Ctrl-Y: Speak the name of the current buffer
Ctrl-S: Save the current buffer
Shift+Home: Move to the beginning of the line
Shift+End: Move to the end of the line
Shift+PgUp: Move to the top of the buffer
Shift+PgDn: Move to the bottom of the buffer
Ctrl-J: Display the character under or to the right of the cursor
Ctrl-K: Display the current column
Ctrl-L: Display the current line
Ctrl-O: Opens a new line below the current line
Ctrl-P: Display up to the next 10 lines of the buffer

Cut, Copy and Paste Commands
-
Shift+Right: Highlight and move right one character
Shift+Left: Highlight and move left one character
Ctrl-C: Copy highlighted text to clipboard
Ctrl-X: Cut highlighted text to clipboard
Ctrl-V: Paste clipboard text into current buffer at cursor
Commands

Ctrl-D: Enter editor debug mode (pry session). Ctrl-d again to return to editor session


Function Keys
-
Snippet Commands
F1: Start recording snippet named for characters to left of cursor
  Press Ctrl-S to save snippet
  Press F1 again to return to current buffer
F2: Playback snippet named for characters to left of cursor
EOD


@hbuffer.name = 'Help Buffer'
