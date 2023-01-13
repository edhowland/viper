rem pager_keys.vsh handles key commands for example program pager.vsh which sources this file
mkdir /v/pager
store { exit } /v/pager/key_q
store { page_back } /v/pager/key_backspace
store &() { saved=:(line_number :_buf); global saved; pager  } /v/pager/key_space
function pg_apply(key) {
   test -x "/v/pager/:{key}" || exec { perr No such key; return false }
   exec "/v/pager/:{key}"
}