function bell() { ruby 'print "\a"' }
function trunc(ch) { ruby 'env[:out].puts args[1][1]' :ch }
function chars() { ruby "env[:out].puts (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).join(' ')"}
function puncts() { ruby 'a=((33..47).to_a + (58..64).to_a + (91..96).to_a + (123..126).to_a).map {|e| "_" + e.chr + "_" }.join(" "); env[:out].puts a' } 
function ctrls() {ruby 'env[:out].puts ("a".."z").to_a.map {|e| "ctrl_#{e}" }.join(" ")' }
alias av="ruby 'puts args.length'"
function mode.keys.alpha() { for i in :(chars) { store &() { echo -n :i | push line/left } /v/modes/viper/key_:{i} } }
function view.keys.alpha() { for i in :(chars) { store &() { echo -n :i  } /v/views/viper/key_:{i} } }
function view.keys.punct() { for i in :(puncts) { key=:(trunc :i); fname=:(echo -n :key | xfkey); store &() { echo -n :key } /v/views/viper/:{fname} } } 
function mode.keys.punct() { for i in :(puncts) { key=:(trunc :i); fname=:(echo -n :key | xfkey); store &() { echo -n :key | push line/left } /v/modes/viper/:{fname} } }
function mode.keys.space() { fname=:(echo -n ' '|xfkey); store &() { echo -n ' '| push line/left } /v/modes/viper/:{fname} }
function view.keys.space() { fname=:(echo -n ' '|xfkey); store &() { echo -n space } /v/views/viper/:{fname} }
function mode.ctrl() { for i in :(ctrls) { store &() { nop } /v/modes/viper/:{i} } }
function view.ctrl() { for i in :(ctrls) { store &() { bell } /v/views/viper/:{i} } }
function apply(ch) { exec /v/modes/viper/:{ch}; exec /v/views/viper/:{ch} }
function install() { 
mode.keys.alpha
mode.keys.punct
view.keys.alpha
view.keys.punct
mode.keys.space
view.keys.space
mode.ctrl
view.ctrl
store &() { nop } /v/modes/viper/unknown
store &() { bell } /v/views/viper/unknown
}
function vip() { loop { fn=:(raw -|xfkey); eq :fn ctrl_q && break; apply :fn } }