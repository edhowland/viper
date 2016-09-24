_mode=viper mode.keys :(printable)
kname=:(echo -n ' '|xfkey)
_mode=viper bind :kname { echo -n ' ' | push line/left } { echo -n space }
_mode=viper bind ctrl_i { handle.tab } { echo -n tab }
_mode=viper bind ctrl_m { handle.return } { cat }
_mode=viper bind move_down { move.down } { cat }
_mode=viper bind move_up { move.up } { cat }
_mode=viper bind move_left { move.left } { peek line/right | xfkey | xfkey -h }
_mode=viper bind move_right { move.right } { (eq 0 :(wc < line/right) && bell) || peek line/right | xfkey | xfkey -h } 

