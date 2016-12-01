mkdir /v/exts/default
_ext=/v/exts/default; global _ext
store { autoindent=false; global autoindent; checker=check_default; global checker } ":{_ext}/pre_hook"
function check_default() { echo No syntax check for this file type }
checker=check_default; global checker
alias check=':checker'
function resolve_ext(name) {
test -z :name && perr resolve_ext missing argument && return false
exec /v/exts/default/pre_hook
_ext=/v/exts/default; global _ext
ext=:(pathmap '%x' :name)
test -z :ext && return
extp="/v/exts/:{ext}"
test -f :extp || return
pre=":{extp}/pre_hook"
test -f :pre && exec :pre
_ext=:extp; global _ext
}
