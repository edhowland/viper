# package vish_unit created from charm package new
pdir=":{__DIR__}/vish_unit.d"
mpath=":{pdir}/modules::{mpath}"

# runs all tests in the current directory that start with test_*.vsh
fn test_all() {
      source ":{pdir}/bin/vish_unit.vsh"
   #source ":{pdir}/bin/debug.vsh"
   main
}

