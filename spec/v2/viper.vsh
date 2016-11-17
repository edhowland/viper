_mode=viper mode_keys :(printable)
kname=:(echo -n ' '|xfkey)
_mode=viper bind :kname { ins :_buf ' ' } { echo -n space }
_mode=viper bind move_down { capture { down :_buf; line :_buf } } { cat }
_mode=viper bind move_up { capture { up :_buf; line :_buf } } { cat }
_mode=viper bind move_left { back :_buf } { at :_buf }
_mode=viper bind move_right { fwd :_buf } { at :_buf }
_mode=viper bind ctrl_j { nop } { at :_buf }
_mode=viper bind ctrl_k { nop } { col :_buf }
_mode=viper bind ctrl_l { nop } { line :_buf }
_mode=viper bind key_backspace { del :_buf } { echo -n delete :(xfkey | xfkey -h) }
_mode=viper bind ctrl_m { echo | ins :_buf } { echo -n new line }
_mode=viper bind key_delete { del_at :_buf } { echo -n delete :(xfkey | xfkey -h) }
function next() { rotate /v/modes/viper/metadata/buffers; _buf=:(peek /v/modes/viper/metadata/buffers); global _buf }
function prev() { rotate -r /v/modes/viper/metadata/buffers; _buf=:(peek /v/modes/viper/metadata/buffers); global _buf }
_mode=viper bind ctrl_t { next } { echo -n buffer is now :(basename :_buf) }
_mode=viper bind ctrl_i { apply_times :indent key_space } { echo -n tab }
_mode=viper bind key_backtab { apply_times :indent key_backspace } { echo -n back tab }
_mode=viper bind fn_2 { nop } { echo -n buffer :(basename :_buf) }
_mode=viper bind ctrl_s { save } { echo -n buffer :(basename :_buf) saved to :(cat < ":{_buf}/.pathname") }
_mode=viper bind move_shift_pgup { beg :_buf } { line :_buf }
_mode=viper bind move_shift_pgdn { fin :_buf } { echo -n bottom of buffer }
_mode=viper bind ctrl_q { nop } { exit }
_mode=viper bind ctrl_p { pager } { cat }
_mode=viper bind move_shift_home { front_of_line :_buf } { at :_buf }
_mode=viper bind move_shift_end { back_of_line :_buf } { at :_buf }
_mode=viper bind ctrl_o { back_of_line :_buf; echo | ins :_buf } { at :_buf }
_mode=viper bind fn_4 { marker :_buf } { echo -n mark set }
_mode=viper bind ctrl_c { copy :_buf | cat > :_clip } { echo -n copy }
_mode=viper bind ctrl_x { cut :_buf | cat > :_clip } { echo -n cut }
_mode=viper bind ctrl_v { cat < :_clip | ins :_buf } { echo -n paste }
_mode=viper bind ctrl_f { srch_meth="srch_fwd :{_buf}"; global srch_meth } { change_modebuf search /v/search; echo -n search forward }
_mode=viper bind ctrl_r { srch_meth="srch_back :{_buf}"; global srch_meth } { change_modebuf search /v/search; echo -n search back }
_mode=viper bind ctrl_g { fwd :_buf; :srch_cmd } { rline :_buf }
_mode=viper bind meta_d { nop } { change_modebuf delete :_buf; echo -n delete }

