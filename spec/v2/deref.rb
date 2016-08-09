# deref - class Deref - Dereferences a variable given some starting hash


class Deref
  def initialize symbol
    @key = symbol
  end
  def call frames:, env:{}
    var = frames[@key]
    result = var.split
    if result.length > 1
      return result
    else
      return result[0]
    end
  end
  def to_s
    ':' + @key.to_s
  end
end

