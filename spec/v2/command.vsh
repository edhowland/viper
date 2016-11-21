mkbuf /v/command
mkarray /v/command/bufstack
mkarray /v/command/modestack
_mode=command mode_keys :(printable)
kname=:(echo -n ' '|xfkey)
_mode=command bind :kname { ins :_buf ' ' } { echo -n space }
_mode=command bind move_down { capture { down :_buf; line :_buf } } { cat }
_mode=command bind move_up { capture { up :_buf; line :_buf } } { cat }
_mode=command bind move_left { back :_buf } { at :_buf }
_mode=command bind move_right { fwd :_buf } { at :_buf }
_mode=command bind ctrl_j { nop } { at :_buf }
_mode=command bind ctrl_k { nop } { col :_buf }
_mode=command bind ctrl_l { nop } { line :_buf }
_mode=command bind key_backspace { del :_buf } { echo -n delete :(xfkey | xfkey -h) }
_mode=command bind key_delete { del_at :_buf } { echo -n delete :(xfkey | xfkey -h) }
_mode=command bind move_shift_home { front_of_line :_buf } { at :_buf }
_mode=command bind move_shift_end { back_of_line :_buf } { at :_buf }
_mode=command bind move_shift_pgup { beg /v/search } { line /v/search }
_mode=command bind move_shift_pgdn { fin /v/search } { echo -n bottom of search buffer }
_mode=command bind ctrl_m { pattern=:(line /v/search); at_fin /v/search && (echo | ins /v/search); srch_cmd=":{srch_meth} :{pattern}"; global srch_cmd } { restore_modebuf; :srch_cmd; rline :_buf }

