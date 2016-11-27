mkdir /v/exts/default
_ext=/v/exts/default; global _ext
store { autoindent=false; global autoindent } ":{_ext}/pre_hook"
function resolve_ext(name) {
test -z :name && perr resolve_ext missing argument && return false
exec ":{_ext}/pre_hook"
ext=:(pathmap '%x' :name)
test -z :ext && return
extp="/v/exts/:{ext}"
test -f :extp || return
 pre=":{extp}/pre_hook"
echo trying :pre
test -f :pre && exec :pre
}
