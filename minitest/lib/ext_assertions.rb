# ext_assertions.rb: Extended assertions over MiniTest assert methods
def assert_false obj
  assert obj == false
end


# ditto. Replace with assert_equal
def assert_equals val1, val2
  assert_equal val1, val2
end
# Possibly ok
def assert_neq val1, val2
  assert val1 != val2
end

# This one might be ok
def assert_not_empty obj
  if obj.respond_to? :empty?
  assert_false obj.empty?  
  else
    assert false
  end
end


def assert_not_nil obj
  assert !obj.nil?
end
# Probably ok, too
def assert_is obj, klass
  assert obj.instance_of?(klass)
end




# Used for mocking here

