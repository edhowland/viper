#!/usr/bin/env  vish

import lib
#source unit_utils.vsh
#source assert.vsh

# If the developer has supplied a helper file for use here
# test -f helper.vsh && source helper.vsh
source ":{pdir}/helpers/helper.vsh"

fn main(seed) {
   cond { test -z ":{seed}" } { echo  will  generate a  new seed for  shuffling } else { echo  A supplied  seed value of  :seed will be used for shuffling }
   echo clearing all previous logs
   clear_logs
   echo  loading all test files
   add_all_test_files
   echo runing tests in random order
   run_all_tests :seed
   echo  log of  tests
   error_log
   # log_of_tests

   echo  stats
   stats

   echo  Vish unit tests completed
}

