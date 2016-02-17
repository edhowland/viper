# find.rb - method find - match string pattern in buffer

def find buffer, pattern
  Viper::Session[:searches] ||= []
  buffer.srch_fwd (pattern || Viper::Session[:searches][-1] || //)
  Viper::Session[:searches] << pattern unless pattern.nil?
end

def rev_find buffer, pattern
  Viper::Session[:searches] ||= []
  buffer.srch_back(pattern || Viper::Session[:searches][-1] || //) 
  Viper::Session[:searches] << pattern unless pattern.nil?
end
