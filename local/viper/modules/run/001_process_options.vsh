rem process_opts.vsh process any command line options like -e 'command args' or -l 99
cond { test -d /v/options/viper/actual/e } {
__res=''; __sep=''
cd "/v/options/viper/actual"
for i in e/* { __res1=:(cat :i); __res=":{__res} :{__sep} :{__res1}"; __sep=';' }
test -z :__res || eval :__res
}
  cd :proj
