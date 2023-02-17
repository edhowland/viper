rem load_vishrc Loads the Users .vishrc or the projects .vishrc if they exist
test -X ":{HOME}/.vishrc" && source ":{HOME}/.vishrc"
test -X ":{chome}/rc" && source ":{chome}/rc"/rc"
test -X ":{proj}/.vishrc" && source ":{proj}/.vishrc"
