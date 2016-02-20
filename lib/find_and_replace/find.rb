# find.rb - method find - match string pattern in buffer

def find buffer, pattern
  Viper::Session[:searches] ||= []
  buffer.fwd if pattern.nil?
  memo = buffer.position
  buffer.srch_fwd (pattern || Viper::Session[:searches][-1] || //)
  Viper::Session[:searches] << pattern unless pattern.nil?
  Viper::Session[:search_direction] = :find
  buffer.position != memo
end

def rev_find buffer, pattern
  Viper::Session[:searches] ||= []
  memo = buffer.position
  buffer.srch_back(pattern || Viper::Session[:searches][-1] || //) 
  Viper::Session[:searches] << pattern unless pattern.nil?
  Viper::Session[:search_direction] = :rev_find
  memo != buffer.position
end

# search again in the last direction
def again buffer
  Viper::Session[:search_direction] ||= :find
  send Viper::Session[:search_direction], buffer, nil
end
