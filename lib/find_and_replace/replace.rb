# replace.rb - method replace - finds pattern, replaces it if found

def replace(buffer, pattern = nil, sub = nil)
  Viper::Session[:replacements] ||= []
  result = find buffer, pattern
  if result
    pattern = Viper::Session[:searches][-1]
    buffer.match pattern
    contents = buffer.match_data[0]
    contents.length.times { buffer.del_at }
    buffer.ins((sub || Viper::Session[:replacements][-1]))
    Viper::Session[:replacements] << sub unless sub.nil?
    Viper::Session[:search_direction] = :replace
    true
  else
    say BELL
    false
  end
end
