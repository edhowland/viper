rem install_pkg.vsh will take its mandatory 2 arguments and cp -r the contents of arg1 to the directory listed in arg2
mandate_argc 4 :argc 'package install' || exit 1
install_it :(subarg :argv) :(fifth :argv)
