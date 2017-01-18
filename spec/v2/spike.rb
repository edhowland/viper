# spike.rb - spike simple tests like xUnit

$befores = []
$tests = []
$afters = []


module Nameable
  attr_accessor :name
end

class ProcName
  include Nameable
end

def closure &blk
  yield
end

def test &blk
  $tests << blk
end


def before &blk
  $befores << blk
end
at_exit do 
  result = $tests.map do |e|
    begin
      e.call
    rescue => err
      err
    end
end
  p result
end
