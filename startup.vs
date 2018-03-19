# startup.vs - tie all together
a=getargs()
b=openf(:a[0])
q=mkq(:b)
buf=Buffer(:b, :q, :a[0])
# read symbol
defn rsym() {
  readc() | tr()  # sym()
}
# perform action
defn run(b) {
  ch=rsym()
  %b[:ch] | prints()
}

