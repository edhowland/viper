rem process_s source files in -s lines
function process_s(mod) {
  cd "/v/options/:{mod}/actual/s"
  for s in * { cd :proj; src=:(cat :s); source :src; suppress { cd - } }
  cd :proj
}
