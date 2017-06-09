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
  mdparse ":{vhome}/doc/help/001_help.md" /v/help/001_help
  echo -n Now in help loop
  peek /v/help/001_help
  _mode=help loop {
      key=:(raw - |xfkey)
      eq :key escape && break
      apply :key
    }
    echo -n back to previous mode :_mode
}
_mode=help bind key_space { rotate /v/help/001_help; peek /v/help/001_help } { cat }
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
