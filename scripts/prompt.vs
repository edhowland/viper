# prompt.vs - prompt?(msg) - prints msg, waits  forinput, ture if 'y'
defn prompt?(msg) {
  print(:msg)
  read() == 'y'
}
defn mkprompt(msg) {
  ->(item) { prompt?(:msg + :item + '? ') }
}

