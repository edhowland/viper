function chars() {ruby "puts (('a'..'z').to_a + ('A'..'Z').to_a).join(' ')"}
alias av="ruby 'puts args.length'"
function mode_keys() { for i in :(chars) { store &() { echo -n :i | push line/left } /v/modes/viper/key_:{i} } }
function view_keys() { for i in :(chars) { store &() { echo -n :i  } /v/views/viper/key_:{i} } }
function controls() { store &() { break } /v/modes/viper/ctrl_q }
function apply(ch) { exec /v/modes/viper/:{ch}; exec /v/views/viper/:{ch} }
