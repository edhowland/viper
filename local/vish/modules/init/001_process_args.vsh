rem process_args.vsh process any possible command line options
__FILE__=init
mkvalopts s e
parseopts
rem tasks to performafter these scripts have been loaded
rem we have been placed in another present working directory
__FILE__=init
for s in :(getvalopt -s) { cd :proj; source :s; cd :proj }
cond { test -d /v/options/init/actual/e } {
__res=''; __sep=''
cd "/v/options/:{__FILE__}/actual"
for i in e/* { __res1=:(cat :i); __res=":{__res} :{__sep} :{__res1}"; __sep=';' }
test -z :__res || eval :__res
}
suppress { cd - }
