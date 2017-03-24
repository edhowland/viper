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

def assert_false expr
  assert(!(expr), 'Expected expression to be false, got true')
end

def assert_diff left, right, message=''
  left.chars.each_with_index do |e, i|
    assert e == right[i], "strings differ at offset #{i} : left: #{e} : right #{right[i]}\n#{left}\n#{right}"
  end
  assert left.length == right.length, "strings are of different lengths: left #{left.length} right #{right.length}\n#{[left, right].max.bytes[([left, right].min.length)..-1].inspect}"
end
def assert_eq left, right
  assert(left == right, "Expected #{left} to equal #{right}")
end
def assert_equals left, right
  assert_eq left, right
end

def assert_neq left, right
  assert left != right, "Expected #{left.to_s} to not equal #{right.to_s}"
end
def assert_is actual, klass
  assert(klass === actual, "Expected #{actual} to be instance of #{klass}, got #{actual.class.name}")
end

def assert_nil obj
  assert obj.nil?, "expected #{obj} to be nil"
end
def assert_not_nil obj
  assert !obj.nil?, 'Expected object to not be nil, but was nil'
end

class AssertionRaiseFailure < BaseAssertionException; end

def assert_raises exception, &blk
  assert(false, 'assert_raises: Must supply a block') unless block_given?
  begin
    yield
    raise AssertionRaiseFailure.new  "Expected block to raise #{exception.name}, got none"
  rescue AssertionRaiseFailure => err
    raise err
  rescue => err
    assert exception  === err, "Expected block to raise #{exception.name}, but got #{err.class.name} with message #{err.message}"
  end
end

def assert_empty coll
  assert coll.empty?, 'Expected collection to be empty, but was not'
end

def assert_not_empty coll
  assert !coll.empty?, 'Expected collection to not be empty, but was'
end
# skips
class SkippedTest < RuntimeError
end

def skip message='skipped'
  raise SkippedTest.new(message)
end
