# passing.rb - all tests pass

require_relative 'spike'


closure do 
  test do 
    assert true
  end

  test do 
    assert_eq 1, 1
  end

  test do 
    assert_is 1, Fixnum
  end
end
