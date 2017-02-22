# test spike.rb

require_relative 'spike'

# The closure block is so we can use lexical closures to wrap variables: e here
closure do 
  e = 0

  before do 
    e = 1
  end

  test do 
    r = e + 1
    assert(r == 2, 'expected 2') 
  end

  test do 
    r = e * 10
    assert_eq r, 10
  end

  test do 
    r = e - 2
    assert_eq r, 0
  end
  
  after do 
    e = 0
  end

  test do 
    assert_is e, String
  end

  test do 
    fail 'bad juju'
  end

  test do 
    skip
  end
  
  test do 
    skip 'skipped because I am lazy'
  end
  end

