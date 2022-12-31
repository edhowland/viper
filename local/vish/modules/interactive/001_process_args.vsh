rem process_args.vsh process any possible command line options
__FILE__=repl
mkboolopts v
mkvalopts s e
parseopts
rem tasks to performafter these scripts have been loaded
process_v repl
process_s repl
process_e repl
