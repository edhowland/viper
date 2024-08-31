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
cat < :_buf | ifs='x' read result
assert_eq ":{result}" ' world'
}
# experiment with parts of original method
function x_del_word_fwd(buf) {
word=:(word_fwd :buf)
test -z :word && return false
len=:(echo -n :word | wc)
echo "The word :{word} length is :{len}" > test.log
r="1..:{len}"
   for i in :r { 
      del_at :buf 
   } | nop
}
function test_x_del_word_fwd() {
echo -n 'hello world' | ins :_buf
beg :_buf
   x_del_word_fwd :_buf
   assert :exit_status
cat < :_buf | ifs='x' read result
assert_eq ":{result}" ' world'
}