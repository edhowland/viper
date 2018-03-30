# a0.vs - first test of stuff

defn file_txt(file) {
  fread(:file) | mkbuf()
}
args=getargs()
b=file_txt(:args[1])
q=mkquery(:b)


