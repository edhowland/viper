# canonical.rb - method canonical - returns string ClassName from class_name

def canonical(string)
  parts = string.split('_')
  parts.map(&:capitalize).join('')
end
