#!/usr/bin/env  vish

source unit_utils.vsh

fn  main() {
   add_all_test_files
   shuffle :(test_fns)
}
