mkmode prompt
function prompt_yn(message) {
mkbuf /v/prompt
echo -n :message '[y/n]'
prompter
test -z :response && response=n
eq :response 'y' || eq :response 'Y'
}
function prompter() {
_mode=prompt _buf=/v/prompt loop {
key=:(raw -|xfkey)
eq :key ctrl_m && break
apply :key
}
response=:(line /v/prompt); global response
}
_mode=prompt mode_keys :(printable)

