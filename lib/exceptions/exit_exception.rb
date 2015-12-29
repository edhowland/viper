# exit_exception.rb - exception ExitException

class ExitException < RuntimeError
  def initialize
    super 'Exiting ...'
  end
end

