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
_mode=viper mkhelp fn_3 F3 asks for key and speaks its action
_mode=viper mkhelp fn_2 F2 speaks the name of the current buffer with possible star if it is modifie
_mode=viper mkhelp fn_1 F1 speaks the status of the editor with number of buffers open
_mode=viper mkhelp fn_4 F4 Sets the default mark underline at the current character position
