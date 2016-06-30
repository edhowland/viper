# visher - class Visher - wraps Vish parser with parse! method
require_relative 'vish.kpeg'
class Visher
  class << self
    def check! statement
      v = Vish.new statement
      v.parse
    end
    
    def parse! statement
      v = Vish.new statement
      puts 'syntax Error' unless v.parse
      # remove any comment-only nodes from the result
      v.result  # .map {|e| e.reject(&:nil?) }
    end
  end
end


def vepl
  vm = VirtualMachine.new
  begin
    loop do
      print 'vepl-> '
      command = gets
      fail if command.nil?
      command = command.chomp
      block = Visher.parse! command
      vm.call block
     end
   rescue => err
     puts 'Exiting ...'
    end
end

def vtos
  begin
    loop { print 'vtos'; v=Visher.parse!(gets.chomp);  puts v.to_s }
  rescue => err
    puts err.message
  end
end

def vdbg
  begin
    loop { print 'vdbg'; v=Visher.parse!(gets.chomp);  p v }
  rescue => err
    puts err.message
  end
end


