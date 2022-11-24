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
    if args.length != 2 || !Hal.virtual?(args[0]) || !Hal.exist?(args[1])
      env[:err].puts "openf: Argument error. Must have 2 arguments: actual buffer and existing file"
      return false
    end
    perform(args[0], env: env, frames: frames) do |node|
            buffer = node['buffer']
    buffer[]= File.read(args[1]).chars
    ''
    end
    true
  rescue Errno::EACCES => err
    env[:err].puts "openf: permission denied for #{args[1]}"
    return false
  end
end