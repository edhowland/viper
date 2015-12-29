# display_help.rb - say Help text

@hbuffer = ReadOnlyBuffer.new <<EOD
Control Character Commands

Ctrl-Q: Quit editing
Ctrl-H: Display this Help Text
Ctrl-J: Display the character under or to the right of the cursor
Ctrl-K: Display the current column
Ctrl-L: Display the current line
EOD


@hbuffer.name = 'Help Buffer'
