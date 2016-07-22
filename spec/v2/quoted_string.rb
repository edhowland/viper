# quoted_string - class QuotedString - single quoted string - '' - Root of  all
# strings. Will not interpolate them

class QuotedString
  def initialize string
    @storage = string
  end
  def call frames:, env:{}
    @storage.to_s
  end
  def to_s
    @storage.to_s
  end
end

