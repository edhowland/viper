#!/usr/bin/env  vish

source unit_utils.vsh
source assert.vsh

fn  main() {
   echo clearing all previous logs
   clear_logs
   echo  loading all test files
   add_all_test_files
   echo runing tests in random order
   run_all_tests
   echo  log of  tests
   error_log
   # log_of_tests

   echo  stats
   stats

   echo  Vish unit tests completed
}

