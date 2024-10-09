mod test_slice_of {
function test_slice_of_works() {
  x=:(slice_of 0 2 foobar)
  assert_eq :x "foo"
}
function test_slice_of_from_middle_to_end() {
  x=:(slice_of 3 -1 foobar)
  assert_eq :x "bar"
}
function test_slice_of_works_with_read_input() {
  echo foobar | read x
  x=:(slice_of 0 2 :x)
  assert_eq :x "foo"
}
function test_slice_of_using_stdin() {
  echo -n foobar | slice_of 0 2 - | read x
  assert_eq :x "foo"
}
}

