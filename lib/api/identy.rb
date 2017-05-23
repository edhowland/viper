# identy.rb - define method :identy for some collection classes


class Hash
  def identy
    :to_h
  end
end

class String
  def identy
    :to_s
  end
end

class Array
  def identy
    :to_a
  end
end

class StringIO
  def identy
    :string
  end
end
