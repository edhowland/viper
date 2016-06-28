# redirection - class Redirection - holder for >, <, >> 2> stuff


require_relative 'context_constants'
class Redirection
include Element
  def initialize op, target
    @op = op
    @target = target
  end
  def ordinal
    REDIR
  end
end
