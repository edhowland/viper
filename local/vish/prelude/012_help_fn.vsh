# help_fn command let to print the docstring for a function
cmdlet help_fn '{ out.puts("#{@_frames.functions[@args[0]].doc}") }'
