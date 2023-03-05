rem project_vishrc.vsh is there a project level .vishrc
if_file ":{proj}/.vishrc" "There is already a .vishrc in your current project directory :{proj}" "There is no .vishrc in your current project :{proj}. It can be created from a template with charm config project"
