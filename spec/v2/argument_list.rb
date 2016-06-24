# argument_list - classArgumentList - holds array of Arguments 

class ArgumentList
  def initialize list
    @storage = list
  end
  def call frames:
    @storage.map { |e| e.call frames:frames }
  end
  def to_s
    @storage.map {|a| a.to_s }.join(' ')
  end
end

