function delete_line() {
front_of_line :_buf; mark :_buf; down :_buf; cut :_buf | cat > :_clip
}
function delete_front() {
mark :_buf; front_of_line :_buf; cut :_buf | cat > :_clip
}
function delete_back() {
mark :_buf; back_of_line :_buf; cut :_buf | cat > :_clip
}
function delete_beg() {
mark :_buf; beg :_buf; cut :_buf | cat > :_clip
}
function delete_fin() {
mark :_buf; fin :_buf; cut :_buf | cat > :_clip
}
function clear_line() {
  delete_back; delete_front
}
function do_delete() {
key=:(raw -|xfkey)
_sup=:key; global _sup
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
