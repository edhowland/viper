
module TimeExtensions
  refine Integer do
    def minutes
      self * 60
    end
  end
end

class MyApp
  using TimeExtensions

  def initialize
    p 2.minutes
  end

  def say(num)
    puts num.minutes
  end
end
