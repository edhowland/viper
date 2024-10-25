# quoted_string - class QuotedString - single quoted string - '' - Root of  all
# strings. Will not interpolate them

class QuotedString
  include ClassEquivalence

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
    class_eq(other) && (other.storage == self.storage)
  end
end
