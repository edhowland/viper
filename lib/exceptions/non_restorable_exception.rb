# non_restorable_exception.rb - exception NonRestorableException
# NonRestorable raised when attepting to restore a non-restorable Buffer
class NonRestorableException < RuntimeError
  def initialize(cname)
    super "Buffers of type #{cname} cannot be restored"
  end
end
