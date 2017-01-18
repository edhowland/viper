# test spike.rb

require_relative 'spike'

closure do 
  test do 
    1 + 1
  end
  
  test do 
    5 * 3
    fail
  end

  end

