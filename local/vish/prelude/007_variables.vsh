rem gvariables.vsh global variables
rem mv this CommandLet to another file in this dir
cmdlet rb_scriptname '{ out.puts $PROGRAM_NAME }'
shell=:(rb_scriptname)
checker=check_default
chome=":{HOME}/.config/vish"
PATH=:(env PATH)
SHELL=:(env SHELL)
