mkdir /v/exts/.rb
function checkrb() { cat < :_buf | sh - ruby -c }
store { autoindent=true; global autoindent; checker=checkrb; global checker } /v/exts/.rb/pre_hook
function dumprb() { json /v/macros/.rb > ruby.json }
function loadrb() { json -r /v/macros/.rb < ruby.json }
test -f ruby.json && loadrb

