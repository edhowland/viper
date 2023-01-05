rem options.vsh setup options for viper editor
__FILE__=viper; global __FILE__
mkboolopts h v i
mkvalopts s e l
sethelpbanner viper The Viper code and text editor
sethelpbanner This is version :version
sethelpbanner ""
setopthelp s "source.vsh" Sources the file before starting the editor
setopthelp e "command args" Evaluates the command before starting the editor
setopthelp i Reads from standard in into a buffer called standard_in
setopthelp l "line#" Gotos to the line number after loading the first buffer
setopthelp h Prints this help message and exits
setopthelp v Prints the Vish version number and exits
