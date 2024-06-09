rem setting.vsh sets up global variables for termfiles
rem if using MacOS Terminal.app undo the term_program variable and set it to xterm
eq :term_program "Apple_Terminal" && term_program=xterm
termfile=":{lhome}/etc/keymaps/:{term_program}.json"
