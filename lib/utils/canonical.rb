# canonical.rb - method canonical - returns string ClassName from class_name

def canonical string
  parts  = string.split('_')
  parts.map { |e| e.capitalize }.join('')
end

