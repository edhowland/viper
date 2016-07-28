function mr() { deq lx/right | push lx/left; peek lx/right; echo }
function ml() { pop lx/left | enq lx/right; peek lx/right; echo }
function ex() { loop { raw char; eq :char 'q' && break;   echo -n :char | push line/left; echo -n :char } }
alias getch="raw - | xfkey"
function inkey() { ch=:(getch); global ch; eval :(cat < /v/modes/viper/:{ch}) }
function inkey2() { ch=:(raw - |xfkey); global ch }
function viper() { loop { inkey2; eq 'Q' :ch && break; eval :(cat < /v/views/:{_mode}/:{ch}); eval :(cat < /v/modes/:{_mode}/:{ch}) } }
function lit(ch) { echo -n "echo -n ':{ch}' | push line/left" > /v/modes/viper/:{ch}; echo -n "echo -n ':{ch}'" > /v/views/viper/:{ch} }
function lit2(ch, name) { echo -n "echo -n ':{ch}' | push line/left" > /v/modes/viper/:{name}; echo -n "echo -n ':{ch}'" > /v/views/viper/:{name} }
function lineno() { ruby "puts (':{pwd}'.split('/').count {|e| e == 'nl' } + 1)" }
json modes.viper.json /v/modes/viper
json views.viper.json /v/views/viper
function search(pat) { loop { (grep :pat < line || not { cd nl }) && break } }
