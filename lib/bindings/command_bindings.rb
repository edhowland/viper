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
    :s => ->(b, *args) { b.fname = args[0]; b.save; say "#{b.name} saved. Buffer is now #{b.name}" },
    :g => ->(b, *args) { b.goto(args[0].to_i); say b.line },
    :n => ->(b, *args) { $buffer_ring.rotate!; say "Buffer is now #{$buffer_ring[0].name}" },
    :p => ->(b, *args) { $buffer_ring.rotate!(-1); say "Buffer is now #{$buffer_ring[0].name}" },
    :o => ->(b, *args) { $buffer_ring.unshift(FileBuffer.new(args[0])); say "Open file #{$buffer_ring[0].name}" },
    :k! => ->(b, *args) { killed = $buffer_ring.shift; say "#{killed.name} destroyed" }
  }
end
