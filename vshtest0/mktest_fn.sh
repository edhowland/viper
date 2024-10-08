#!/bin/bash
cat >>  $3 <<EOD
function ${1}() {
  run_glob "'${2}'" &() { map_pairs &(x, y) { assert_eq :y :x } :_ }
}
EOD
