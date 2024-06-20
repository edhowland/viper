rem new sub command of charm package creates directory of a new Vish package or plugin
pname=:(subarg :argv)
pvsh=":{pname}/:{pname}_pkg.vsh"; pdird=":{pname}.d"
echo Creating new package source directory in ":{pname}/"
mkdir ":{pname}/:{pname}.d/modules"
echo "rem package :{pname} created from charm package new" > :pvsh
join '' 'pdir=":{__DIR__}/' ":{pname}.d" '"' >> :pvsh
echo 'mpath=":{pdir}/modules::{mpath}"' >> :pvsh
