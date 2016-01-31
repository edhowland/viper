# non_restorable_exception.rb - exception NonRestorableException

class NonRestorableException < RuntimeError
  def initialize cname
    super "Buffers of type #{cname} cannot be restored"
  end
end

