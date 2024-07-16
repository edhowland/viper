# token.rb - class Token : the Token data type

# token enums

EOF = 0xFF
NEWLINE = 0xFE
def token_names(type)
  case type
  when EOF
    "<EOF>"
  when NEWLINE
    "<new line>"
  else
    "!Unknown!"
  end
end

class Token
  # remember where our lines start at
  @@line_number = 1
  def initialize(contents, type: EOF)
    @contents = contents
    @type = type
    if @type == NEWLINE
      @@line_number += 1
    end
    @line_number = @@line_number
  end
  attr_reader :contents, :type, :line_number

  def to_s
    "content: >#{@content}<, type: #{token_names(@type)}, line: #{@line_number}"
  end
end
