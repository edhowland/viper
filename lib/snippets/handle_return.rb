# handle_return.rb - method handle_return - given a buffer insert newline and indent


def handle_return buffer
  indent_level = buffer.indent_level
  buffer.ins "\n"
  indent_level.times { buffer.ins ' ' }
end
