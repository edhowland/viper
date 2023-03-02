rem cmdlets.vsh builtin CommandLets
cmdlet is_true '{ return false if argc.zero?; return true if (args[0].kind_of?(TrueClass) || args[0] == "true"); return false }'
cmdlet is_false '{ return false if argc.zero?; return true if (args[0].kind_of?(FalseClass) || args[0] == "false"); return false }'
cmdlet compgen '{ Dir[args[1]].length.zero? ? false : true }'
rem is_tty returns true if input is coming from user or false if a pipe
cmdlet is_tty '{ inp.isatty }'
