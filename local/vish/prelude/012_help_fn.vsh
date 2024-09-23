# help_fn command let to print the docstring for a function
cmdlet help_fn '{ die(msg: "Wrong  number of arguments") if @args.length == 0; out.puts("#{@_frames.functions[@args[0]].help}") }'

# get only the docs for a function and do not reformat it
cmdlet help_fn_doc '{ die(msg: "Wrong  number of arguments") if @args.length == 0; out.puts("#{@_frames.functions[@args[0]].doc}") }'

