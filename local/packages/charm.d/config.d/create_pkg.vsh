rem create the subcommand of charm config create will populate the HOME/.config/vish folder if it does not exist
echo Looking for :chome
cond { test -d :chome } { echo :chome already exists } else { echo Will populate :chome; populate_chome }
