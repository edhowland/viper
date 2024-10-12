source glob_help.vsh
function test_no_glob() {
  run_glob 'aa3' &(x,y) { assert_eq :x :y }
}
function test_glob_aastar() {
  run_glob 'aa*' &() { map_pairs &(x, y) { assert_eq :x :y } :_ }
}
function test_glob_quest_a_question() {
  run_glob '?a?' &() { map_pairs &(x, y) { assert_eq :x :y } :_ }
}
function test_glob_aa2_star_txt() {
  run_glob 'aa2/*.txt' &() { map_pairs &(x, y) { eq :y :x || raise Expected :y to eq :x } :_ }
}
function _test_bad() {
  raise bad
}
function test_glob_astar_star_txt() {
  run_glob 'aa*/*.txt' &() { map_pairs &(x, y) { assert_eq :x :y } :_ }
}
function test_glob_aa1_star_txt() {
  run_glob 'aa1/*.txt' &(s1,p1, s2, p2) { assert_eq :s1 :p1 }
}
function test_glob_star_groom_star() {
  run_glob "'*/groom.*'" &() { map_pairs &(x, y) { assert_eq :y :x } :_ }
}
function test_star_star_star_spider_sh() {
  run_glob "'*/*/*/spider.sh'" &() { map_pairs &(x, y) { assert_eq :y :x } :_ }
}
function test_d1_e2_range_bracket_1_3() {
  run_glob "'d1/e2/range[1-3]'" &() { map_pairs &(x, y) { assert_eq :y :x } :_ }
}
function test_glob_d1_e2_range_brack_1_3() {
  run_glob "'d1/e2/range[13]'" &() { map_pairs &(x, y) { assert_eq :y :x } :_ }
}
