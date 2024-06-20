rem install package with charm package install source_folder dest_folder
mandate_argc 2 :argc "charm package install" || exit 1
pkg_=:(subarg :argv); dest_d=:(subarg2 :argv)
echo about to install :pkg_ in location :dest_d
lpath=:old_lpath install_it :pkg_ :dest_d || exit 1
