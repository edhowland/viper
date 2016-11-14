_mode=viper mode_keys :(printable)
_mode=viper bind move_down { down :_buf } { line :_buf }
_mode=viper bind move_up { up :_buf } { line :_buf }
_mode=viper bind move_left { back :_buf } { at :_buf }
_mode=viper bind move_right { fwd :_buf } { at :_buf }
_mode=viper bind ctrl_j { nop } { at :_buf }
_mode=viper bind ctrl_k { nop } { col :_buf }
_mode=viper bind ctrl_l { nop } { line :_buf }

