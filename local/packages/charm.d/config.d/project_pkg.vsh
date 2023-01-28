rem project the subcommand for charm config project will populate current dir with .vishrc
proj_vishrc=":{proj}/.vishrc"
echo Looking for :proj_vishrc
cond { test -X :proj_vishrc } { nop } else { echo Creating :proj_vishrc from template; cp ":{__DIR__}/templates/proj_vishrc" :proj_vishrc }
