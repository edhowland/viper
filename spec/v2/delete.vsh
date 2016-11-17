_mode=delete bind key_d { nop } { echo -n line; restore_modebuf }
_mode=delete bind move_shift_home { nop } { echo -n to beginning of line; restore_modebuf }
_mode=delete bind move_shift_end { nop } { echo -n to end of line; restore_modebuf }
_mode=delete bind move_shift_pgup { nop } { echo -n to top of buffer; restore_modebuf }
_mode=delete bind move_shift_pgdn { nop } { echo -n to bottom of buffer; restore_modebuf }
