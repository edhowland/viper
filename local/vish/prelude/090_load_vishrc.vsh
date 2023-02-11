rem load_vishrc Loads the Users .vishrc or the projects .vishrc if they exist
test -f ":{HOME}/.vishrc" && source ":{HOME}/.vishrc"
test -f ":{proj}/.vishrc" && source ":{proj}/.vishrc"
