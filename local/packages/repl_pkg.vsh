rem repl_pkg.vsh the package for the ivsh REPL
import option_processing
import interactive
rem stub for the help command
function help(topic) {
   perr The help subsystem has not yet been loaded
   perr to load it enter "load help_base"
   perr then retry help :topic
}

