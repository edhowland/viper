mod test_buffer {
function test_buffer_at_is_empty_string_w_empty_buffer() {
  o scratch1
  result=:(at :_buf)
  assert_eq :result ''
}
}
