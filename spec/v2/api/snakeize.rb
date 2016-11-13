# snakeize.rb - method snakeize CamelCase to camel_case

def snakeize string
  string.gsub(/([A-Z])/, "_\\1").downcase[1..-1]
end