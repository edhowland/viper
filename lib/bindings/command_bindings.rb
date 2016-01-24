# command_bindings.rb - method command_bindings returns hash of command procs

def command_bindings
  {
    :q => ->(b, *args) { :quit },
    :q! => ->(b, *args) { exit },
    :w => ->(b, *args) {
      if args.empty?
        b.save; say "#{b.name} saved" 
      else
        say "saving to #{args[0]}"
        File.write(args[0], b.to_s)
      end
    },
    :wq => ->(b, *args) { b.save; say "#{b.name} saved"; exit },
    :rew! => ->(b, *args) { b.restore; say "#{b.name} restored"},
    :r => ->(b, *args) {
      if File.exist?(args[0])
        b.ins(File.read(args[0]))
      else
        say "#{args[0]} does not exist"
      end
    },
    :r! => ->(b, *args) { insert_shell(b, *args) },
    :s => ->(b, *args) { b.fname = args[0]; b.save; say "#{b.name} saved. Buffer is now #{b.name}" },
    :g => ->(b, *args) { b.goto(args[0].to_i); say b.line },
    :goto => ->(b, *args) { offset = args[0].to_i; b.goto_position(offset); say b.line },
    :n => ->(b, *args) { $buffer_ring.rotate!; say "Buffer is now #{$buffer_ring[0].name}" },
    :p => ->(b, *args) { $buffer_ring.rotate!(-1); say "Buffer is now #{$buffer_ring[0].name}" },
    :o => ->(b, *args) { $buffer_ring.unshift(FileBuffer.new(args[0])); say "Open file #{$buffer_ring[0].name}" },
    :k! => ->(b, *args) { killed = $buffer_ring.shift; say "#{killed.name} destroyed" },

    # clipboard commands
    :yank => ->(b, *args) { $clipboard = b.line; say '1 line yanked' },

    # start of :help commands
    :help => ->(b, *args) { $buffer_ring.unshift(help_buffer); say "Buffer is now #{$buffer_ring[0].name}" },

    # check syntax, lint etc.
    :check => ->(b, *args) { check_ruby_syntax(b) },
    :pipe => ->(b, *args) { pipe(b, *args) },
    :pipe! => ->(b, *args) { pipe!(b, *args) },
    :lint => ->(b, *args) { lint(b) },
    :new => ->(b, *args) { $buffer_ring.unshift  ScratchBuffer.new; say "new buffer: #{$buffer_ring[0].name}"},
    :report => ->(b, *args) { say "Buffer: #{b.name} position: #{b.position} association #{b.association}" },

    # snippet commands
    :slist => ->(b, *args) {say "Loaded Snippet Collections are:\n"; $snippet_cascades.keys.each {|k| say "#{k}\n" } }, 
    :list => ->(b, *args) {
      say "Available snippets for #{args[0]}\n"
      $snippet_cascades[args[0].to_sym].keys.each {|k| say "#{k}\n" } 
    }, 
    :sedit => ->(b, *args) { b.clear; b.ins $snippet_cascades[args[1].to_sym][args[0]]; b.beg; say b.line },
    :snip => ->(b, *args) {
      name = args[0]
        cascade = args[1].to_sym
        create_snippet(cascade, name, b)
      say "Saved buffer to snippet: #{name} in collection #{args[1]}"
    },
    :apply => ->(b, *args) {
      snip = args[0]
        cascade = args[1].to_sym
      apply_snippet cascade, snip, b
      say b.line
    },
    :dump => ->(b, *args) {
      cascade = args[1].to_sym
      path = args[0]
      dump_snippets cascade, path
      say "Snippets: #{cascade} saved to #{path}.json"
    },

    :load => ->(b, *args) {
      cascade = args[1].to_sym
      path = args[0]
      load_snippets cascade, path
      say "Snippets #{cascade} loaded from #{path}.json"
    },

    :assocx => ->(b, *args) { $file_associations.ext args[0], args[1].to_sym; say "Extension saved for association #{args[1]}" },
    :assocf => ->(b, *args) { $file_associations.file args[0], args[1].to_sym; say "File association saved for #args[1]}" },
    :assocd => ->(b, *args) { $file_associations.dir args[0], args[1].to_sym; say "Directory saved for association #{args[1]}" },
    :tab => ->(b, *args) { handle_tab(b) },
    # NOP: just repeat the args
    :nop => ->(b, *args) {puts 'you said';  args.each {|e| puts e} }
  }
end
