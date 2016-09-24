_mode=viper mode.keys :(printable)
kname=:(echo -n ' '|xfkey)
_mode=viper bind :kname { echo -n ' ' | push line/left } { echo -n space }
_mode=viper bind ctrl_i { handle.tab } { echo -n tab }
_mode=viper bind ctrl_m { handle.return } { cat }
