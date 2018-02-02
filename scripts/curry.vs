# curry.vs - fn curry(fn, arg) - returns new fn w/arg as new parm
defn curry2(fn, arg) {
  ->(a2) {  %fn(:arg, :a2) }
}
defn curry1(fn, arg) {
  ->() { %fn(:arg) }
}

