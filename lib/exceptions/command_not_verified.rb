# command_not_verified.rb - exception CommandNotVerified

class CommandNotVerified < RuntimeError
  def initialize
    super 'Command could not be verified. Command sequence was not performed'
  end
end
