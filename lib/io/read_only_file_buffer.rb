# read_only_file_buffer.rb - class ReadOnlyFileBuffer

# ReadOnlyFileBuffer subclass of FileBuffer including module NonWritable making it read-only.
class ReadOnlyFileBuffer < FileBuffer
  include NonWritable

  def save
    say BELL
  end
end
