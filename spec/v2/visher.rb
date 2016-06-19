# visher - class Visher - wraps Vish parser with parse! method
require_relative 'vish.kpeg'
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

def vdbg
  begin
    loop { print 'vdbg'; v=Visher.parse!(gets.chomp); puts; p v }
  rescue => err
    puts err.message
  end
end

Signal.trap("SIGQUIT") { exit }
