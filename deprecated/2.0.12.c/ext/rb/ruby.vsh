mkdir /v/exts/.rb
function checkrb() { cat < :_buf | sh - ruby -c }
store { autoindent=true; global autoindent; checker=checkrb; global checker } /v/exts/.rb/pre_hook
function dumprb() {
jpath=":{vhome}/ext/rb/ruby.json"
 json /v/macros/.rb > :jpath
}
function loadrb() {
jpath=":{vhome}/ext/rb/ruby.json"
test -f :jpath && json -r /v/macros/.rb < :jpath
}
loadrb
function run_testrb() {
  path=:(cat < ":{_buf}/.pathname")
  sh "ruby :{path}"
}

