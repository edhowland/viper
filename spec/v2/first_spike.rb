# test spike.rb

require_relative 'spike'

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
    5 * 3
    fail
  end

  end



binding.pry
