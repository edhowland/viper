rem options.vsh utility functions for parsing command line options
alias mkboolopts='test -d "/v/options/:{__FILE__}" || mkdir "/v/options/:{__FILE__}/expected" "/v/options/:{__FILE__}/actual" "/v/options/:{__FILE__}/help"; each &(f) { touch "/v/options/:{__FILE__}/expected/:{f}" }'
alias mkvalopts='test -d "/v/options/:{__FILE__}" || mkdir "/v/options/:{__FILE__}/expected" "/v/options/:{__FILE__}/actual" "/v/options/:{__FILE__}/help"; each &(d) { mkdir "/v/options/:{__FILE__}/expected/:{d}" }'
cmdlet optof '{  res=/--?([A-Za-z_]+)/.match(args[0])&.to_a&.fetch(1);out.puts res; !res.nil?  }'
function booloptq(o) {
  name=:(optof :o) && test -X "/v/options/:{__FILE__}/expected/:{name}"
  }
function valoptq(o) {
  name=:(optof :o) && test -d "/v/options/:{__FILE__}/expected/:{name}"
}
function optq(o) {
  name=:(optof :o) && test -f "/v/options/:{__FILE__}/expected/:{name}"
}
function setboolopt(o) {
  o=:(optof :o)
  touch "/v/options/:{__FILE__}/actual/:{o}"
}
function setvalopt(o, val) {
  o=:(optof :o)
  mkdir "/v/options/:{__FILE__}/actual/:{o}"
  touch "/v/options/:{__FILE__}/actual/:{o}/:{val}"
}
function getboolopt(o) {
  o=:(optof :o)
  test -X "/v/options/:{__FILE__}/actual/:{o}"
}
function getvalopt(o) {
  o=:(optof :o)
  actualoptq :o && (cd "/v/options/:{__FILE__}/actual/:{o}"; echo *)
}
function recopt(maybe_opt, maybe_val) {
  optq :maybe_opt || exec { echo :maybe_opt :maybe_val :_; return }
  cond { booloptq :maybe_opt } {
    setboolopt :maybe_opt
    recopt :maybe_val :_
  } { valoptq :maybe_opt } {
    setvalopt :maybe_opt :maybe_val
    recopt :_
  } else { raise Unexpected option :maybe_opt }
}
function parseopts() {
  argv=:(recopt :argv); global argv
}
function actualoptq(o) {
  test -f "/v/options/:{__FILE__}/actual/:{o}"
}