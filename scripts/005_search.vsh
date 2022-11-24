mkbuf /v/search
mkarray /v/search/bufstack
mkarray /v/search/modestack
function compose_srch_cmd(dir) {
  at_fin /v/search && up /v/search
  pattern=:(line /v/search)
  pattern=":{pattern}"
  srch_cmd=&() { :dir :_buf ":{pattern}" }
  global srch_cmd
}
function searcher() {
fin /v/search
_mode=search _buf=/v/search loop {
key=:(raw -|xfkey)
eq :key ctrl_m && break
apply :key
}
at_fin /v/search && echo | ins /v/search | nop
}
kname=key_space
_mode=search bind :kname { ins :_buf ' ' } { echo -n space }
_mode=search bind move_down { capture { down :_buf; line :_buf } { bell } } { cat }
_mode=search bind move_up { capture { up :_buf; back_of_line :_buf; line :_buf } { bell } } { cat }
_mode=search bind move_left { capture { back :_buf } { bell } } { at :_buf }
_mode=search bind move_right { capture { fwd :_buf } { bell } } { at :_buf }
_mode=search bind ctrl_j { nop } { at :_buf }
_mode=search bind ctrl_k { nop } { col :_buf }
_mode=search bind ctrl_l { nop } { line :_buf }
_mode=search bind key_backspace { del :_buf } { echo -n delete :(xfkey | xfkey -h) }
_mode=search bind key_delete { del_at :_buf } { echo -n delete :(xfkey | xfkey -h) }
_mode=search bind move_shift_home { front_of_line :_buf } { at :_buf }
_mode=search bind move_shift_end { back_of_line :_buf } { at :_buf }
_mode=search bind move_shift_pgup { beg /v/search } { line /v/search }
_mode=search bind move_shift_pgdn { fin /v/search } { echo -n bottom of search buffer }
_mode=search bind ctrl_b { nop } { break }
_mode=search bind ctrl_q { nop } { perr Search aborted;  break }
_mode=search bind ctrl_backslash { nop } { exit }

