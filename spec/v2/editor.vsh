function key.exists(key) { test -f "/v/modes/:{_mode}/:{key}" }
function apply.first(key) { exec "/v/modes/:{_mode}/:{key}" }
function apply.second(key) { exec "/v/views/:{_mode}/:{key}" }
function apply(ch) { (key.exists :ch || bell) && apply.first :ch | apply.second :ch }
function apply.times(count, key) { range=1..:{count}; for i in :range { apply.first :key } }
function ctrls() {ruby 'env[:out].puts ("a".."z").to_a.map {|e| "ctrl_#{e}" }.join(" ")' }
function mode.keys() { 
for i in :_ {
key=:(echo -n :i | xfkey)
bind :key &() { echo -n :i | push line/left } &() { echo -n :i } 
}
}
function printable() {
uc=A..Z lc=a..z nu=0..9 pu1='!../' pu2=':..@' pu3='[..`' pu4='{..~'
echo :lc :uc :nu :pu1 :pu2 :pu3 :pu4
}
