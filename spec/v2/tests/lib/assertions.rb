# assertions.rb - methods for assert and its kin

def ignore_this_file list
      list.map {|e| e.split(':') }.reject {|e| e[0] == __FILE__ }.map {|e| e.join(':') }
end

class BaseAssertionException < RuntimeError
  def backtrace
    # super.map {|e| e.split(':') }.reject {|e| e[0] == __FILE__ }.map {|e| e.join(':') }
    super
  end
end

class AssertionFailure < BaseAssertionException
end

def assert expr, message='Expected true, got false'
  raise AssertionFailure.new(message) unless expr
end

def assert_eq left, right
  assert(left == right, "Expected #{left} to equal #{right}")
end
def assert_equals left, right
  assert_eq left, right
end

def assert_is actual, klass
  assert(klass === actual, "Expected #{actual} to be instance of #{klass}, got #{actual.class.name}")
end

def assert_nil obj
  assert obj.nil?, "expected #{obj} to be nil"
end
class AssertionRaiseFailure < BaseAssertionException; end

def assert_raises exception, &blk
  begin
    yield
    raise AssertionRaiseFailure.new  "Expected block to raise #{exception.name}, got none"
  rescue AssertionRaiseFailure => err
    raise err
  rescue => err
    assert exception  === err, "Expected block to raise #{exception.name}, but got #{err.class.name} with message #{err.message}"
  end
end

# skips
class SkippedTest < RuntimeError
end

def skip message='skipped'
  raise SkippedTest.new(message)
end
