rem vish subcommand for the charm config vishrc
home_vishrc=":{HOME}/.vishrc"
echo looking for :home_vishrc
cond { test -X :home_vishrc } { echo Found it } else { echo Creating :home_vishrc; cp ":{__DIR__}/templates/home_vishrc" :home_vishrc  }
