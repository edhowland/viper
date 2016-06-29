# alias_declaration - class AliasDeclaration - alias name="expansion"

class AliasDeclaration
  def initialize name, expansion
    @name = name
    @expansion = expansion
  end
  def call env:, frames:
    frames.aliases[@name] = @expansion
  end
end
