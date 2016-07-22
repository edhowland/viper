# deref - class Deref - Dereferences a variable given some starting hash


class Deref
  def initialize symbol
    @key = symbol
  end
  def call frames:, env:{}
    frames[@key]
  end
  def to_s
    ':' + @key.to_s
  end
end

