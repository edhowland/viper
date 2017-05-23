mkdir /v/keys/viper
function help_key(key) {
  pth="/v/keys/:{_mode}/:{key}"
  ifelse { test -f :pth } { 
  cat < :pth } {
    echo no help for key :key in mode :_mode }
}
function key_prompt() {
  echo -n Enter key to hear its action
  key=:(raw - | xfkey)
  help_key :key
}
function help() {
  echo in help
}
function mkhelp(key) {
  echo :_ > "/v/keys/:{_mode}/:{key}"
}
