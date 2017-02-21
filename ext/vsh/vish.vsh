mkdir /v/exts/.vsh
function checkvsh() { 
  capture { cat < :_buf | vsh_parse } { echo Syntax Error }
}
store { autoindent=true; global autoindent; checker=checkvsh; global checker } /v/exts/.vsh/pre_hook
function dumpvsh() {
jpath=":{vhome}/ext/vsh/vish.json"
json /v/macros/.vsh > :jpath
}
function loadvsh() {
jpath=":{vhome}/ext/vsh/vish.json"
test -f :jpath && json -r /v/macros/.vsh < :jpath
}
loadvsh
function evalvsh() {
  capture { vsh_parse aa < :_buf } { echo Syntax error } {  exec :aa }
}

