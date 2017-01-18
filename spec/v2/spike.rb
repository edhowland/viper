# spike.rb - spike simple tests like xUnit

$befores = []
$tests = []
$afters = []

class Passed
  def message
    'Passed'
  end
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

# execution phase
def combine list
  list.map { |e| $befores + [e] + $afters }
end


def lambdaize list
  list.map {|e| ->() { e.each {|f| f.call } } }
end

def run list
list.map do |e|
  begin
    e.call
    Passed.new
  rescue => err
    err
  end
end
end

# statistics
def passed list
  list.count {|e| Passed === e }
end

def failures list
  list.reject {|e| Passed === e }.length
end

def stats list
  puts <<EOD
  Total: #{list.length}
  Passed: #{passed(list)}
  Failures: #{failures(list)}
EOD
end

# main
def main
  c = combine $tests
  l = lambdaize c
  r = run l
  stats r
end
#at_exit do 
  #result = $tests.map do |e|
    #begin
      #e.call
    #rescue => err
      #err
    #end
#end
  #p result
##end
