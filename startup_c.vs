# startup.vs - tie all together
myfname='file.txt'
a=getargs()
b=openf(:myfname)
q=mkq(:b)
buf=Buffer(:b, :q, :myfname)
# read symbol
defn rsym() {
  readc() | tr()  # sym()
}
# perform action
defn run(b) {
  ch=rsym()
  %b[:ch] | prints()
}

