mkdir /v/exts/.vsh
function checkvsh() { echo tbd syntax checker for vish source buffer }
store { autoindent=true; global autoindent; checker=checkvsh; global checker } /v/exts/.vsh/pre_hook
function dumpvsh() { json /v/macros/.vsh > vish.json }
function loadvsh() { json -r /v/macros/.vsh < vish.json }
test -f vish.json && loadvsh

