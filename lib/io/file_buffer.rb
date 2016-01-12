# file_buffer.rb - class FileBuffer

class FileBuffer < Buffer
  include Recordable
  def initialize filename
    @fname = filename
    if File.exist? @fname
    super(File.read(@fname))
    else
    super ''
  end
    @name = @fname
  end

  attr_reader :fname

  def fname= name
    @fname = name
    @name = @fname
  end


  def save
    File.write(@fname, to_s)
    @dirty = false
  end

  def restore
    @a_buff = StringBuffer.new ''
    @b_buff = StringBuffer.new(File.read(@name))
    @dirty = false
  end

end
