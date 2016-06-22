# argument - class Argument - holds an argument which be given to a command


class Argument
  def initialize thing
    @storage = thing
  end
  def call frames:
    @storage.call frames:frames
  end
end

