# quoted_string - class QuotedString - single quoted string - '' - Root of  all
# strings. Will not interpolate them

class QuotedString
  def initialize string
    @storage = string
  end
  def call frames:
    @storage.to_s
  end
end

