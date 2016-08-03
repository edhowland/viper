# visher - class Visher - wraps Vish parser with parse! method
require_relative 'vish.kpeg'

class Vish
  class SyntaxError < RuntimeError
    def initialize 
      super 'syntax error'
    end
  end
end

class Visher
  class << self
    def check! statement
      v = Vish.new statement
      v.parse
    end
    
    def parse! statement
      v = Vish.new statement
      raise Vish::SyntaxError unless v.parse
      # remove any comment-only nodes from the result
      v.result  # .map {|e| e.reject(&:nil?) }
    end
  end
end

# starts the repl for vish engine
def vepl options={}
  vm = VirtualMachine.new
  begin
    # load any startup scripts
    vishrc = File.dirname(File.expand_path(__FILE__)) + '/etc/vishrc'
    if File.exist?(vishrc) && options[:no_start].nil?
      code = File.read(vishrc)
      cblock = Visher.parse! code
      vm.call cblock
    end

    loop do
      begin
      print vm.fs[:prompt]
      command = gets
      fail if command.nil?
      command = command.chomp
      next if command.empty?
      block = Visher.parse! command
      vm.call block
   rescue Vish::SyntaxError => err
     vm.ios[:err].puts err.message
     vm.fs[:exit_status] = false
   end
     end

   rescue => err
      puts err.message
      puts err.backtrace[0]
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


