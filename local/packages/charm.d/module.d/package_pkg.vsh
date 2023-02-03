rem package the subcommand for charm module package tries to find the modules in the  supplied package
rem usage charm module package package_name
rem lists charm.d/modules/charmutils
arg=:(subarg :argv)
echo arg is :arg
new_lpath=:(lpath=:old_lpath package_exists :arg) || exec { perr :arg not found in package search path; exit 1 }
echo new_lpath is :new_lpath
(cd  ":{new_lpath}/:{arg}.d/modules"; ls)

