# mark_not_set.rb - exception MarkNotSet

#MarkNotSet raised when a cut or copy operation was attempted, but no mark in the buffer was set. 
class MarkNotSet < RuntimeError
end
