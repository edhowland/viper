function debugging() { true }
alias k="raw -|xfkey"
alias l="echo *"
alias u="raw -|xfkey -u"
alias xd="raw - | xfkey -d"
alias xe="echo :exit_status"
alias x='echo :_status'
function pb(name, snip) {
for k in :(cat < "/v/macros/:{snip}/:{name}") {
echo -n :k; raw ab
logger got :k
suppress { applyf :k }
}
}
function cprb(snip) {
mkarray /v/stuff
for i in :(cat < "/v/macros/.rb/:{snip}") {
echo :i | enq /v/stuff 
}
}
alias f='mark_first :_mark'
alias n='mark_next :_mark'
alias p='mark_prev :_mark'
alias sm='save_macro'
alias em="edit_macro"
function g(ln) {
  goto :_buf :ln | nop; line :_buf
}
test -f .vishrc && source .vishrc

