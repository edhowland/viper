# a0.vs - first test of stuff

defn file_txt(file) {
  fread(:file) | mkbuf()
}
args=getargs()
file_name=:args[1]
b=file_txt(:args[1])
q=mkquery(:b)
# utility functions
defn undefined?(o) {
  :o == 'undefined'
}


