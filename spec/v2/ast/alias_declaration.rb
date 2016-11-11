# alias_declaration - class AliasDeclaration - alias name="expansion"

class AliasDeclaration
  def initialize name, expansion
    @name = name
    @expansion = expansion
  end
  def call env:, frames:
    string = @expansion.call env:env, frames:frames
    frames.aliases[@name] = string
  end
  def to_s
    "alias #{@name}=\"#{@expansion}\""
  end
end
