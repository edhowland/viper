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
    r = e * 10
    fail unless r == 10
  end

  end



