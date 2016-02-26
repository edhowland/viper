# read_only_buffer.rb - class ReadOnlyBuffer

# ReadOnlyBuffer subclass of Buffer which is read-only. NonWritable and NonRecordable.
class ReadOnlyBuffer < Buffer
  include NonWritable
  include NonRecordable
end
