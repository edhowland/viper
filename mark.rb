# mark.rb - class Mark - pair of string pointer and position

class Mark
  def initialize string, position
    @string = string
    @position = position
  end
  attr_reader :string, :position
  def inspect
    "#{self.class.name}: string length: #{@string.length}, position: #{@position}"
  end
end
