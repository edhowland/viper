mkdir /v/exts/.rb
store { autoindent=true; global autoindent } /v/exts/.rb/pre_hook
alias check="cat < :_buf | sh - ruby -c"
function dumprb() { json /v/macros/.rb > ruby.json }
function loadrb() { json -r /v/macros/.rb < ruby.json }
test -f ruby.json && loadrb

