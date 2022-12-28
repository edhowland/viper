rem process_args.vsh process any possible command line options
__FILE__=repl
mkvalopts s e
parseopts
rem tasks to performafter these scripts have been loaded
process_e repl
