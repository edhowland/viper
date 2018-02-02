# scratch.vs - get the lambda to create scratch names
defn iter() { var=0; ->() { var=:var + 1; :var } }
defn mkscratch() {
  it=iter()
  ->() { "scratch:{%it}" } }

