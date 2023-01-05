rem process_args.vsh process any possible command line options
__FILE__=init
mkboolopts c v h
mkvalopts s e
sethelpbanner vish The script  runner for Vish scritp files
sethelpbanner This is version :version
sethelpbanner ""
setopthelp c Performs syntax check on all arguments and exits
setopthelp s "<Vish_source.vsh>" Sources the Vish file and executes it before processing script
setopthelp e "<vish_command args>" Evaluates the vish commands before processing the script
setopthelp h Prints this help message and exits
setopthelp v Prints the version of Vish and exits
parseopts
rem tasks to performafter these scripts have been loaded
