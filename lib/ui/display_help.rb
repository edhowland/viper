# display_help.rb - say Help text

def display_help
  say <<EOD
Control Character Commands

Ctrl-Q: Quit editing
Ctrl-H: Display this Help Text
Ctrl-J: Display the character under or to the right of the cursor
Ctrl-K: Display the current column
Ctrl-L: Display the current line
EOD
end
