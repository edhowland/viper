# a0.vs - first test of stuff

defn file_txt() {
  fread('file.txt') | mkbuf()
}
b=file_txt()
q=mkquery(:b)


