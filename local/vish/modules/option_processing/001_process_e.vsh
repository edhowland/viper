rem process_e.vsh handler for the -e flag if needed
function process_e(mod) {
cond { test -d /v/options/:{mod}/actual/e } {
      __res=''; __sep=''
cd "/v/options/:{mod}/actual"
for i in e/* { __res1=:(cat :i); __res=":{__res} :{__sep} :{__res1}"; __sep=';' }
      test -z :__res || eval "cd :proj; :{__res}"
}
  cd :proj
}