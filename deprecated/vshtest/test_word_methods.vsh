function setup_buf() {
  open xxx
  __obuf=:_buf; global __obuf
  new_clip
}
function test_beg() {
   echo -n hello world | ins :_buf
   beg :_buf
   assert_eq 0 :(position :_buf)
}
function test_word_fwd() {
   echo -n hello world | ins :_buf
   beg :_buf
   w=:(word_fwd :_buf)
   len=:(echo -n :w | wc)
   assert_eq 5 :len
}
function test_del_at() {
   echo -n hello world | ins :_buf
   beg :_buf
   len=6
   r="1..:{len}"
   for i in :r {
      del_at :_buf
   }
   assert_eq "world" :(cat :_buf)
}
function test_del_word_fwd() {
echo -n 'hello world' | ins :_buf
beg :_buf
del_word_fwd :_buf
   beg :_buf; fwd :_buf
assert_eq 'w' :(at :_buf)
}
