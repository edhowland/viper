#!/usr/bin/env  vish

source unit_utils.vsh
source assert.vsh

fn  main() {
   echo  loading all test files
   add_all_test_files
   echo runing tests in random order
   run_all_tests
   echo  log of  tests
   log_of_tests

   echo  Vish unit tests completed
}

