# deref - class Deref - Dereferences a variable given some starting hash

class Deref
  def initialize symbol
    @key = symbol
    @value = ''
  end
  attr_reader :key, :value
  def resolve! frames:
    @value = frames[@key]
  end
  def handle_range
    r = Range.new @matches[1], @matches[2]
    r.to_a
  end
  def range?
    @matches = @value.match /([^.]+)\.\.(.+)/
    !@matches.nil?
  end
  def call frames:, env:{}
    resolve! frames:frames
    var = @value
    case var
    when String
      if range?
        return handle_range
      end
    result = var.split
    if result.length > 1
      return result
    else
      return result[0]
    end
    else
      return var
    end
  end
  def to_s
    ':' + @key.to_s
  end
end

