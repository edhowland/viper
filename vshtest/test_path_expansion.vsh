function test_type_finds_v_tmp_bin_program() {
  mkdir /v/tmp/bin
  cp /v/bin/basename /v/tmp/bin
  path=:(join ":" /v/tmp/bin :path)
  type basename | slice_of 8 -1 - | read result
  assert_eq :result "/v/tmp/bin/basename"
}
function test_type_finds_v_bin_program() {
  path=:(join ":" /v/tmp/bin :path)
  type cat | slice_of 8 -1 - | read result
  assert_eq :result "/v/bin/cat"
}
