# array_writer - class ArrayWriter - wraps Array

class ArrayWriter
  def initialize(io)
    @io = io
  end
  attr_reader :io
  # must use send here to invoke method on object in this subtree
  def write(string)
    @io.send(:clear)
    string.chars.each { |c| @io.send(:<<, c) }
  end

  def puts(string)
    write "#{string}\n"
  end

  def close
    # nop
  end
end
