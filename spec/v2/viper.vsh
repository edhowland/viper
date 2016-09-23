function chars() { ruby "env[:out].puts (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).join(' ')"}
function mode.keys.alpha() { 
for i in :(chars) {
key=:(echo -n :i | xfkey)
bind :key &() { echo -n :i | push line/left } &() { echo -n :i } 
}
}
