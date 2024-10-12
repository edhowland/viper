# test_clip.vsh tests clipboard functions

mod test_clip {
function setup() {
  open xxx
  __obuf=:_buf; global __obuf
}
function teardown() {
  rm :__obuf
  unset _buf
  unset _clip
}
function test_new_clip() {
   new_clip
   test -z ":{_clip}"
   assert_false :exit_status
}
function test_clip_buf_exists() {
   echo -n hello world | ins :_buf
   new_clip
   test -f :_clip
   assert :exit_status
}
}
