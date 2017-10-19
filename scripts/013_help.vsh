mkdir /v/help
mkdir /v/history
mkarray /v/history/help
mkmode help
each &(mode) { mkdir "/v/keys/:{mode}" } viper help
function help_hist(doc, ignore) {
  eq :ignore ignore || (echo :doc | enq /v/history/help)
    }
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
function help_parse(doc) {
  hdoc="/v/help/:{doc}"
  test -f :hdoc || mdparse ":{vhome}/doc/help/:{doc}.md" :hdoc
}
function help(doc) {
  test -z :doc && doc=help
  help_qlaunch :doc
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
function help_qlaunch(doc, ignore) {
  help_parse :doc; unset _help; _help="/v/help/:{doc}"; global _help
  help_hist :doc :ignore
  echo -n now in; _mode=help apply fn_2
}
_mode=help bind key_v { help_qlaunch viper;  peek :_help } { cat }
_mode=help bind key_h { help_qlaunch help; peek :_help } { cat }
_mode=help bind key_c { help_qlaunch command; peek :_help } { cat }
_mode=help bind key_s { help_qlaunch vish; peek :_help } { cat }
_mode=help bind fn_2 { echo -n Help Document ':' :(basename :_help) } { cat }
_mode=help bind ctrl_q { exit } { nop }
_mode=help bind fn_1 { xxx=hello; global xxx } { nop }
_mode=help exec {
  bind ctrl_space { capture { help_qlaunch :(link_uri :_help); peek :_help } { perr :last_exception } { echo -n ' ' } } { cat }
  bind key_k { help_qlaunch keys; peek :_help } { cat }
  bind key_rbracket { rotate /v/history/help; help_qlaunch :(peek /v/history/help) ignore; peek :_help } { cat }
  bind key_lbracket { rotate -r /v/history/help; help_qlaunch :(peek /v/history/help) ignore; peek :_help } { cat }
  bind fn_3 { key_prompt } { cat }
}
function mkhelp(key) {
  eq  :_argc 1 && exec { echo "_mode=:{_mode}" mkhelp :key ' '; help_key :key; return true } 
  echo -n :_ > "/v/keys/:{_mode}/:{key}"
}
function load_key_help() {
  json -r "/v/keys/:{_mode}" < ":{vhome}/doc/keys/:{_mode}.json"
}
function save_key_help() {
  json "/v/keys/:{_mode}" > ":{vhome}/doc/keys/:{_mode}.json"
}
_mode=viper load_key_help
_mode=help load_key_help
