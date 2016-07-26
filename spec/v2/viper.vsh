function mr() { deq lx/right | push lx/left; peek lx/right; echo }
function ml() { pop lx/left | enq lx/right; peek lx/right; echo }
function ex() { loop { raw char; eq :char 'q' && break;   echo -n :char | push line/left; echo -n :char } }
function lit(ch) { echo "echo -n ':{ch}' | push line/left" > /v/modes/viper/:{ch} }
function lineno() { ruby "puts (':{pwd}'.split('/').count {|e| e == 'nl' } + 1)" }
