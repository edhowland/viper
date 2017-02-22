# visher - class Visher - wraps Vish parser with parse! method

class Visher
  class << self
    def parse! statement
      v = Vish.new statement
      puts 'syntax Error' unless v.parse
      v.result
    end
  end
end


def vepl
  executor = Executor.new
  loop { print 'vish> '; executor.execute!(Visher.parse!(gets.chomp)) }
end
