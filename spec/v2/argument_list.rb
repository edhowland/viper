# argument_list - classArgumentList - holds array of Arguments 

class ArgumentList
  def initialize list
    @storage = list
  end
  def call frames:
    @storage.map { |e| e.call frames:frames }
  end
end

