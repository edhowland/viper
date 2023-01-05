rem process_args.vsh process any possible command line options
__FILE__=repl
mkboolopts h v
mkvalopts s e
sethelpbanner ivsh The interactive Vish REPL
sethelpbanner This is version :version
sethelpbanner ""
setopthelp s "<Vish_source.vsh>" Sources the Vish file and executes it before starting the interactive input
setopthelp e "<vish_command args>" Evaluates the vish commands before starting the interactive input
setopthelp h Prints this help message and exits
setopthelp v Prints the version of Vish and exits
parseopts
rem tasks to performafter these scripts have been loaded
process_h repl
process_v repl
process_s repl
process_e repl
