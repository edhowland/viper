source ":{vhome}/cmdlet/misc/utils.vsh"
  cmdlet btest -f y '{ ostr = opts[:y] ? "yes" : "no"; out.puts ostr }'
function test_cmdlet_ord_chr_undo_each_other() {
ord f | chr | read result
assert_eq :result f
  chr 63 | ord | read result
  assert_eq :result 63
}
function test_cmdlet_hex_dec_undo_each_other() {
  hex 209 | dec | read result
  assert_eq :result 209
  dec 4e | hex | read result
  assert_eq :result 4e
}
function test_cmdlet_w_bool_flag() {
  btest | read result
  assert_eq :result no
}

