rem git.vsh utils for git access
function has_git() {
   sh "which git" >/dev/null
}
function is_gitdir(dir) {
   test -d ":{dir}/.git"
}