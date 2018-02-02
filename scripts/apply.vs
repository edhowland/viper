# apply.vs - fns apply, 
defn perf() {
  ch=fetch() # get the next char
  fn=decode(ch) # find the function to execute
  %fn
}
x=perf()
:x
