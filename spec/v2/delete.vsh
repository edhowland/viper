function delete_line() {
front_of_line :_buf; marker :_buf; down :_buf; cut :_buf | cat > :_clip
}
function delete_front() {
marker :_buf; front_of_line :_buf; cut :_buf | cat > :_clip
}
function delete_back() {
marker :_buf; back_of_line :_buf; cut :_buf | cat > :_clip
}
function delete_beg() {
marker :_buf; beg :_buf; cut :_buf | cat > :_clip
}
function delete_fin() {
marker :_buf; fin :_buf; cut :_buf | cat > :_clip
}
_mode=delete bind key_d { delete_line } { echo -n line; restore_modebuf }
_mode=delete bind move_shift_home { delete_front } { echo -n to beginning of line; restore_modebuf }
_mode=delete bind move_shift_end { delete_back } { echo -n to end of line; restore_modebuf }
_mode=delete bind move_shift_pgup { delete_beg } { echo -n to top of buffer; restore_modebuf }
_mode=delete bind move_shift_pgdn { delete_fin } { echo -n to bottom of buffer; restore_modebuf }
