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
  echo -n Now in help loop
  _mode=help loop {
      key=:(raw - |xfkey)
      eq :key escape && break
    }
    echo -n back to previous mode :_mode
}
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
