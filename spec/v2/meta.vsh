open scr
function meta(func, buf) {
_mode=viper _buf=:buf fn=:func; preamble="echo -n meta :{_mode} :{_buf} :{fn}"
loop { capture {
:preamble
echo
:fn
} { nop } {
:last_exception
} }
}

