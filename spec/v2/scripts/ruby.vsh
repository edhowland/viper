mkdir /v/exts/.rb
store { autoindent=true; global autoindent } /v/exts/.rb/pre_hook
alias check="cat < :_buf | sh - ruby -c"

