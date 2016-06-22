# deref - class Deref - Dereferences a variable given some starting hash


class Deref
  def initialize symbol
    @key = symbol
  end
  def call frames:
    frames[@key] || ''
  end
end

