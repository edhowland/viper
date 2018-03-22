# startup.vs - tie all together
a=getargs()
myfname=:a[1] # 'file.txt'
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

