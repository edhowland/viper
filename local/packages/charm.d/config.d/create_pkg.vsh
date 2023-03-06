rem create the subcommand of charm config create will populate the HOME/.config/vish folder if it does not exist
echo Looking for :chome
cond { test -d :chome } { echo :chome already exists } else { echo Will populate :chome; populate_chome }
echo Checking for Vish init file ":{chome}/rc" and the packages and plugins directories
cond { test -X ":{chome}/rc" } { echo ":{chome}/rc" exists doing nothing } else { echo will create ":{chome}/rc" from template; cp ":{lhome}/packages/charm.d/config.d/templates/home_vishrc" ":{chome}/rc" }
cond { test -d :cpackages && test :cplugins }  { echo :cpackages and :cplugins already exist doing nothing } else { echo :cpackages or :cplugins may not both exist yet will mkdir them; mkdir :cpackages :cplugins }
