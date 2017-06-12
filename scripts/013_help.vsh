mkdir /v/help
mkmode help
mkdir /v/keys/viper
function help_key(key) {
  pth="/v/keys/:{_mode}/:{key}"
  ifelse { test -f :pth } { 
  cat < :pth } {
    echo no help for key :key in mode :_mode }
}
function key_prompt() {
  perr -n Enter key to hear its action
  key=:(raw - | xfkey)
  help_key :key
}
function help() {
  _help=/v/help/001_help
  mdparse ":{vhome}/doc/help/001_help.md" :_help
  echo -n Now in help loop
  peek :_help
  _mode=help loop {
      key=:(raw - |xfkey)
      eq :key escape && break
      apply :key
    }
    echo -n back to previous mode :_mode
}
_mode=help bind key_space { rotate :_help; peek :_help } { cat }
_mode=help bind move_right { rotate :_help; peek :_help } { cat }
_mode=help bind ctrl_i { hunt :_help BlockHead; peek :_help } { cat }
_mode=help bind move_down { hunt :_help BlockHead; peek :_help } { cat }
_mode=help bind key_backtab { hunt -r :_help BlockHead; peek :_help } { cat }
_mode=help bind move_up { hunt -r :_help BlockHead; peek :_help } { cat }
_mode=help bind key_backspace { rotate -r :_help; peek :_help } { cat }
_mode=help bind move_left { rotate -r :_help; peek :_help } { cat }
_mode=help bind ctrl_l { peek :_help } { cat }
_mode=help bind move_shift_pgup { hunt -t :_help Para; peek :_help } { cat }
_mode=help bind move_shift_pgdn { hunt -t :_help MdBlock; hunt -r :_help MdBlock; peek :_help } { cat }
function mkhelp(key) {
  echo -n :_ > "/v/keys/:{_mode}/:{key}"
}
function load_key_help() {
  json -r "/v/keys/:{_mode}" < ":{vhome}/doc/keys/:{_mode}.json"
}
function save_key_help() {
  json "/v/keys/:{_mode}" > ":{vhome}/doc/keys/:{_mode}.json"
}
_mode=viper load_key_help
