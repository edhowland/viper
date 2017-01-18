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
    fail('expected 2') unless r == 2
  end

  test do 
    r = e * 10
    fail unless r == 10
  end

  test do 
    r = e - 2
    fail("expected 0, got #{r}") unless r == 0
  end
  
  after do 
    e = 0
  end
  end



