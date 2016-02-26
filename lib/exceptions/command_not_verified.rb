# command_not_verified.rb - exception CommandNotVerified
# CommandNotVerified raised when a command was not found within a command string expression.
class CommandNotVerified < RuntimeError
  def initialize
    super 'Command could not be verified. Command sequence was not performed'
  end
end
