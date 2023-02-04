rem new subcommand of charm module new modname creates new module from templates
create_me={ mkdir :dest; cp ":{tplate_dir}/001_sample.vsh" :dest; cp ":{tplate_dir}/on_import.vsh" :dest; echo sample templates copied into :dest }
name=:(subarg :argv); test -z :name && exec { perr You must supply a name for the new module; exit 1 }
pdir=":{pdir}/new.d"; tplate_dir=":{pdir}/templates"
pkg=:(is_package_dir)
cond { not { test -z :pkg } } {
   dest=":{pkg}.d/modules/:{name}"; exec :create_me } else {
      dest=:name; exec :create_me  }
      