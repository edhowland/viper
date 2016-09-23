function key.exists(key) { test -f "/v/modes/:{_mode}/:{key}" }
function apply.first(key) { exec "/v/modes/:{_mode}/:{key}" }
function apply.second(key) { exec "/v/views/:{_mode}/:{key}" }
function apply(ch) { (key.exists :ch || bell) && apply.first :ch | apply.second :ch }
function apply.times(count, key) { range=1..:{count}; for i in :range { apply.first :key } }
function puncts() { ruby 'a=((33..47).to_a + (58..64).to_a + (91..96).to_a + (123..126).to_a).map {|e| "_" + e.chr + "_" }.join(" "); env[:out].puts a' }
function ctrls() {ruby 'env[:out].puts ("a".."z").to_a.map {|e| "ctrl_#{e}" }.join(" ")' }
