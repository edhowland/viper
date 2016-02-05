# command_bindings.rb - method command_bindings returns hash of command procs

def command_bindings
  {
    q: ->(_b, *_args) { :quit },
    q!: ->(_b, *_args) { exit },
    w: lambda { |b, *args|
      if args.empty?
        b.save; say "#{b.name} saved"
      else
        say "saving to #{args[0]}"
        File.write(args[0], b.to_s)
      end
    },
    wq: ->(b, *_args) { b.save; say "#{b.name} saved"; exit },
    rew!: ->(b, *_args) { b.restore; say "#{b.name} restored" },
    r: lambda { |b, *args|
      if File.exist?(args[0])
        b.ins(File.read(args[0]))
        say "Contents of #{args[0]} inserted at cursor"
      else
        say "#{args[0]} does not exist"
      end
    },
    r!: ->(b, *args) { insert_shell(b, *args) },
    g: ->(b, *args) { b.goto(args[0].to_i); say b.line },
    goto: ->(b, *args) { offset = args[0].to_i; b.goto_position(offset); say b.line },
    n: ->(_b, *_args) { $buffer_ring.rotate!; say "Buffer is now #{$buffer_ring[0].name}" },
    p: ->(_b, *_args) { $buffer_ring.rotate!(-1); say "Buffer is now #{$buffer_ring[0].name}" },
    o: ->(_b, *args) { $buffer_ring.unshift(FileBuffer.new(args[0])); say "Open file #{$buffer_ring[0].name}" },
    k!: ->(_b, *_args) { killed = $buffer_ring.shift; say "#{killed.name} destroyed" },

    # clipboard commands
    yank: ->(b, *_args) { $clipboard = b.line; say '1 line yanked' },

    # start of :help commands
    help: ->(_b, *_args) { $buffer_ring.unshift(help_buffer); say "Buffer is now #{$buffer_ring[0].name}" },
    keys: ->(_b, *_args) { help_keys },

    # check syntax, lint etc.
    check: ->(b, *_args) { check_ruby_syntax(b) },
    pipe: ->(b, *args) { pipe(b, *args) },
    pipe!: ->(b, *args) { pipe!(b, *args) },
    lint: ->(b, *_args) { lint(b) },
    new: ->(_b, *_args) { $buffer_ring.unshift ScratchBuffer.new; say "new buffer: #{$buffer_ring[0].name}" },
    report: ->(b, *_args) { say "Buffer: #{b.name} position: #{b.position}Line: #{b.line_number} association #{b.association}" },

    # snippet commands
    slist: ->(_b, *_args) { say "Loaded Snippet Collections are:\n"; $snippet_cascades.keys.each { |k| say "#{k}\n" } },
    list: lambda { |_b, *args|
      say "Available snippets for #{args[0]}\n"
      $snippet_cascades[args[0].to_sym].keys.each { |k| say "#{k}\n" }
    },
    sedit: ->(b, *args) {edit_snippet args[1].to_sym, args[0], b;   b.beg; say b.line },
    snip: lambda { |b, *args|
      name = args[0]
      cascade = args[1].to_sym
      create_snippet(cascade, name, b)
      say "Saved buffer to snippet: #{name} in collection #{args[1]}"
    },
    apply: lambda { |b, *args|
      snip = args[0]
      cascade = args[1].to_sym
      apply_snippet cascade, snip, b
      say b.line
    },
    dump: lambda { |_b, *args|
      cascade = args[1].to_sym
      path = args[0]
      dump_snippets cascade, path
      say "Snippets: #{cascade} saved to #{path}.json"
    },

    load: lambda { |_b, *args|
      cascade = args[1].to_sym
      path = args[0]
      load_snippets cascade, path
      say "Snippets #{cascade} loaded from #{path}.json"
    },

    assocx: ->(_b, *args) { $file_associations.ext args[0], args[1].to_sym; say "Extension saved for association #{args[1]}" },
    assocf: ->(_b, *args) { $file_associations.file args[0], args[1].to_sym; say 'File association saved for #args[1]}' },
    assocd: ->(_b, *args) { $file_associations.dir args[0], args[1].to_sym; say "Directory saved for association #{args[1]}" },
    tab: ->(b, *_args) { handle_tab(b) },

    # Code Coverage support from simplecov
    load_cov: ->(_b, *args) { load_cov args[0]; say "Coverage repor #{args[0]} loaded" },
    cov: ->(b, *_args) { sc = ScratchBuffer.new; sc.name = "Coverage report for #{b.name}"; cov(sc, b.name); $buffer_ring.unshift sc; sc.beg; say sc.name; say sc.line },
    cov_report: ->(_b, *_args) { cov_report; say $buffer_ring[0].name.to_s },

    # NOP: just repeat the args
    nop: ->(_b, *args) { puts 'you said'; args.each { |e| puts e } }
  }
end
