# quoted_string - class QuotedString - single quoted string - '' - Root of  all
# strings. Will not interpolate them

class QuotedString
  def initialize(string)
    @storage = string
  end
  attr_reader :storage

  def call(frames:, env: {})
    @storage.to_s
  end

  def to_s
    @storage.to_s
  end
  def ==(other)
    (other.class == self.class) && (other.storage == self.storage)
  end
end
