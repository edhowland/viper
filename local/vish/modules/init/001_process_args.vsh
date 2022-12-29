rem process_args.vsh process any possible command line options
__FILE__=init
mkboolopts c v
mkvalopts s e
parseopts
rem tasks to performafter these scripts have been loaded
rem we have been placed in another present working directory
__FILE__=init
for s in :(getvalopt -s) { cd :proj; source :s; cd :proj }
