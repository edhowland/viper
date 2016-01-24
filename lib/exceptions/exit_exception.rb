# exit_exception.rb - exception ExitException

# TODO: Class documentation
class ExitException < RuntimeError
  def initialize
    super 'Exiting ...'
  end
end

