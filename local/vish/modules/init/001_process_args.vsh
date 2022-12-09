rem process_args.vsh process any possible command line options
__FILE__=init
mkvalopts s e
parseopts
rem tasks to performafter these scripts have been loaded
rem we have been placed in another present working directory
__FILE__=init
cd :latest_wd
for s in :(getvalopt -s) { source :s }
for e in :(getvalopt -e) { eval :e }
suppress { cd - }
