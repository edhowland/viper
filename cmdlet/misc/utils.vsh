cmdlet ord '{ ival= (argc.zero? ? inp.read.chomp : args[0]); out.puts ival.ord }'
cmdlet chr '{ ival=(argc.zero? ? inp.read.chomp : args[0]);  out.puts(ival.to_i.chr) }'
cmdlet hex '{ ival=(argc.zero? ? inp.read.chomp : args[0]);  out.puts("%0x" % ival.to_i) }'
cmdlet dec '{ ival = (argc.zero? ? inp.read.chomp : args[0]);  out.puts ival.to_i(16) }'


