# display_help.rb - say Help text

@hbuffer = ReadOnlyBuffer.new <<EOD
Control Character Commands

Ctrl-Q: Quit editing
Ctrl-H: Display this Help Text
Ctrl-Y: Speak the name of the current buffer
Ctrl-S: Save the current buffer
Ctrl-A: Move to the beginning of the line
Ctrl-E: Move to the end of the line
Ctrl-T: Move to the top of the buffer
Ctrl-B: Move to the bottom of the buffer
Ctrl-J: Display the character under or to the right of the cursor
Ctrl-K: Display the current column
Ctrl-L: Display the current line
EOD


@hbuffer.name = 'Help Buffer'
