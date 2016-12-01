function debugging() { true }
alias k="raw -|xfkey"
alias l="echo *"
alias u="raw -|xfkey -u"
alias xd="raw - | xfkey -d"
alias x="echo :exit_status"
alias cmd="raise com"
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
_mode=viper bind ctrl_b {k=:(pop /v/stuff); applyf :k; echo -n :k } { cat }
