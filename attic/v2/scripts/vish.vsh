mkdir /v/exts/.vsh
function checkvsh() { 
  capture { cat < :_buf | vsh_parse } { echo Syntax Error }
}
store { autoindent=true; global autoindent; checker=checkvsh; global checker } /v/exts/.vsh/pre_hook
function dumpvsh() { json /v/macros/.vsh > vish.json }
function loadvsh() { json -r /v/macros/.vsh < vish.json }
test -f vish.json && loadvsh
function evalvsh() {
  capture { vsh_parse aa < :_buf } { echo Syntax error } {  exec :aa }
}

