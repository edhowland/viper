# raw_buffer.rb - class RawBuffer

# Represents a normal buffer, but translates raw characters to audible names
class RawBuffer < Buffer
  def at
    value = super
    case value
    when "\r"
      "return"
    when "\t"
      "tab"
    when "\b"
      "back tab"
    else
      value
    end
  end
end
 
