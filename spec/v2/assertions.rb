# assertions.rb - methods for assert and its kin

class AssertionFailure < RuntimeError
end

def assert expr, message='Expected true, got false'
  raise AssertionFailure.new(message) unless expr
end

def assert_eq left, right
  assert(left == right, "Expected #{left} to equal #{right}")
end

def assert_is actual, klass
  assert(klass === actual, "Expected #{actual} to be instance of #{klass}, got #{actual.class.name}")
end