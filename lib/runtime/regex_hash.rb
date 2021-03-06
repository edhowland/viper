# regex_hash - class RegexHash - data structor to use regex'es as keys
# When stored, the key is a Regexp
#  and retrieved it is some potetially matching string
# rubocop:disable Style/DoubleNegation

class RegexHash
  def initialize
    @storage = []
  end

  attr_reader :storage

  def []=(key, value)
    @storage << [key, value]
  end

  def [](key)
    results = @storage.select { |e| !!(key =~ e[0]) }
    results[0][1] unless results.empty?
  end
end
