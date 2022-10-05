cmdlet ord '{ out.puts(inp.read.chomp.ord) }'
cmdlet chr '{ out.puts(inp.read.to_i.chr) }'
cmdlet hex '{ out.puts("%0x" % inp.read.chomp) }'


