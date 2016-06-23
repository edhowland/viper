# crossover - class Crossover - base for Redirect*To*


class Crossover
  def initialize target, other_key
    @target = target
    @other_key = other_key
  end
  attr_accessor :target, :other_key

  def close
    # do nothing
  end
end
