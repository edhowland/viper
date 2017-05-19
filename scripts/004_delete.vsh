function delete_line() {
front_of_line :_buf
pos=:(position :_buf)
  down :_buf
   slice :_buf :pos :(decr :(position :_buf)) | cat > :_clip
}
function delete_front() {
  pos=:(decr :(position :_buf))
  front_of_line :_buf
  slice :_buf :(position :_buf) :pos | cat > :_clip
}
function delete_back() {
  pos=:(position :_buf)
  back_of_line :_buf
  slice :_buf :pos :(decr :(position :_buf)) | cat > :_clip
}
function delete_beg() {
  pos=:(decr :(position :_buf))
  beg :_buf
  slice :_buf 0 :pos | cat > :_clip
}
function delete_fin() {
  pos=:(position :_buf)
  fin :_buf
  slice :_buf :pos :(decr :(position :_buf)) | cat > :_clip
}
function clear_line() {
  front_of_line :_buf
  pos=:(position :_buf)
  back_of_line :_buf
  slice :_buf :pos :(decr :(position :_buf)) | cat > :_clip
}
function perform_delete(key) {
eq :key key_d && delete_line && echo -n line && return
eq :key move_shift_home && delete_front && echo -n to front of line && return
eq :key key_h && delete_front && echo -n to front of line && return
eq :key move_shift_end && delete_back && echo -n to end of line && return
eq :key key_l && delete_back && echo -n to end of line && return
eq :key move_shift_pgup && delete_beg && echo -n to top of buffer && return
eq :key key_k && delete_beg && echo -n to top of buffer && return
eq :key move_shift_pgdn && delete_fin && echo -n to bottom of buffer && return
eq :key key_j && delete_fin && echo -n to bottom of buffer && return
eq :key key_c && clear_line && echo -n clear line && return
eq :key key_W && del_word_back :_buf && echo -n word back && return
eq :key key_w && del_word_fwd :_buf && echo -n word && return
bell && return false  
}
function do_delete() {
key=:(raw -|xfkey)
_sup=:key; global _sup
capture { perform_delete :key } { bell }
}
