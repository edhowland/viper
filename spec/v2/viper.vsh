_mode=viper mode.keys :(printable)
kname=:(echo -n ' '|xfkey)
_mode=viper bind :kname { echo -n ' ' | push line/left } { echo -n space }

