# cloner.rb - method cloner obj - calls appropriate clone method on obj

def cloner obj
  if obj.respond_to? :deep_clone
    obj.deep_clone
  elsif obj.respond_to? :_clone
    obj._clone
  else
    obj.clone
  end
end
