# alias_declaration - class AliasDeclaration - alias name="expansion"

class AliasDeclaration
  include ClassEquivalence

  def initialize(name, expansion, line_number=0)
    @name = name
    @expansion = expansion
    @line_number = line_number
  end
  attr_reader :name, :expansion, :line_number

  def call(env:, frames:)
    string = @expansion.call env: env, frames: frames
    frames.aliases[@name] = QuotedString.new(string)
  end

  def to_s
    "alias #{@name}=\"#{@expansion}\""
  end
  def ==(other)
    class_eq(other) && (other.name == self.name && other.expansion == self.expansion)
  end
end
