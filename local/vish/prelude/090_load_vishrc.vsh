rem load_vishrc Loads the Users .vishrc or the projects .vishrc if they exist
for s in ":{HOME}/.vishrc" ":{chome}/rc" ":{proj}/.vishrc" {
  test -X :s && source :s
}
