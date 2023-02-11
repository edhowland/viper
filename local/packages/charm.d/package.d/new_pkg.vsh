rem new subcommand of charm package creates directory of a new Vish package or plugin
pname=:(cadddr :argv)
pvsh=":{pname}/:{pname}_pkg.vsh"; pdird=":{pname}.d"
echo Creating new package source directory in ":{pname}/"
echo Which will :(has_git || echo not) become a git repository
has_git && exec { sh git init ":{pname}"; (cd :pname; echo ".vishrc" > .gitignore) }
mkdir ":{pname}/:{pname}.d/modules"
echo "rem package :{pname} created from charm package new" > :pvsh
join '' 'pdir=":{__DIR__}/' ":{pname}.d" '"' >> :pvsh
echo 'mpath=":{pdir}/modules::{mpath}"' >> :pvsh
