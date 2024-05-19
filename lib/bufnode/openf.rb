# openf.rb: class Openf and command 'openf'
# Opens a file using fast mode into an existing buffer
# Usage:
# open :_buf filename.txt
#
# File will be read in its entirity from the cursor to the end of the file and thus the buffer
# Caution, will overwrite the current contents  of the buffer from the cursor to the end of the buffer
# This is what you want for new empty buffers just created


class Openf < BaseBufferCommand
  def call(*args, env:, frames:)
    if args.length != 2 || !Hal.virtual?(args[0])
      env[:err].puts "openf: Argument error. Must have 2 arguments: actual buffer and existing file or stdin for reading from standard input"
      return false
    end
    if  (args[1] != 'stdin' && !Hal.exist?(args[1]))
      env[:err].puts "openf: input must come from an existing file or be the string 'stdin' for reading from standard input"
      return false
    end
    perform(args[0], env: env, frames: frames) do |node|
            buffer = node['buffer']
    if args[1] == 'stdin'
      inp = $stdin.read
      $stdin.reopen(File.open('/dev/tty'))
    else
      inp = File.read(args[1])
    end
    buffer[]= inp.chars
    ''
    end
    true
  rescue Errno::EACCES
    env[:err].puts "openf: permission denied for #{args[1]}"
    return false
  end
end