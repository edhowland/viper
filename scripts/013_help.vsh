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
  echo in help
}
function mkhelp(key) {
  echo :_ > "/v/keys/:{_mode}/:{key}"
}
function load_key_help() {
  json -r "/v/keys/:{_mode}" < ":{_mode}.json"
}
function save_key_help() {
  json "/v/keys/:{_mode}" > ":{_mode}.json"
}
