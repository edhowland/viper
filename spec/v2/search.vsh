function setup.search() {
_mode=search
lcase=a..z ucase=A..Z nums=0..9
for k in :lcase :ucase :nums { bind "key_:{k}" &() { echo -n :k | push line/left } &() { echo -n :k } }
for k in :(puncts) { key=:(trunc :k); kname=:(echo -n :key | xfkey); bind :kname &() { echo -n :key | push line/left } &() { echo -n :key } }
space_key=:(echo -n ' ' | xfkey); bind :space_key &() { echo -n ' ' | push line/left } &() { echo -n space }
bind move_shift_pgdn { _mode=viper apply.first move_shift_pgdn } { nop }
bind ctrl_o { _mode=viper apply.first ctrl_o } { _mode=viper apply.second ctrl_o }
bind ctrl_m { pat=:(cat < line); global pat; apply.first ctrl_o } { restore.mode; cd :_loc; :_method :pat; unset pat }
bind key_backspace { _mode=viper apply.first key_backspace } { _mode=viper apply.second key_backspace }
bind key_delete { _mode=viper apply.first key_delete } { _mode=viper apply.second key_delete }
bind move_left { _mode=viper apply.first move_left } { _mode=viper apply.second move_left }
bind move_right { _mode=viper apply.first move_right } { _mode=viper apply.second move_right }
bind move_up { _mode=viper apply.first move_up } { _mode=viper apply.second move_up }
bind move_down { _mode=viper apply.first move_down } { _mode=viper apply.second move_down }
bind ctrl_l { _mode=viper apply.first ctrl_l } { _mode=viper apply.second ctrl_l }
_mode=viper bind ctrl_f { _method="find.forward"; global _method; _loc=:pwd; global _loc; cd /v/search/buf; find . nl &(d) { cd nl } } { echo -n search; chg.mode search }
_mode=viper bind ctrl_r { _method="find.back"; global _method; _loc=:pwd; global _loc; cd /v/search/buf; find . nl &(d) { cd nl } } { echo -n search back; chg.mode search }
_mode=viper bind ctrl_g { exec :find_last } { cat }
}