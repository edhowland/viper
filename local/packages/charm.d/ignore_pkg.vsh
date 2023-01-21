test -X ":{proj}/.gitignore" || exec { perr Nothing to do. There does not appear a .gitignore file here; exit 1 }
test -X ":{proj}/.vishrc" || exec { perr Nothing to do. There is no local .vishrc; exit 2  }
echo ".vishrc" >> .gitignore
echo Your local .vishrc was added to your .gitignore. You may want to run '"git add .gitignore; git commit"'

