# read_only_buffer.rb - class ReadOnlyBuffer

class ReadOnlyBuffer < Buffer
  include NonWritable
end

