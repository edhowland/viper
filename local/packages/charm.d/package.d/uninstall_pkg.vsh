mandate_argc 1 :argc "charm package uninstall" || exit 1
pkg_=:(subarg :argv)
echo about to uninstall :pkg_
lpath=:old_lpath uninstall_it :pkg_ || exit 1

