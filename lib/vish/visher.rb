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
      raise VishSyntaxError unless v.parse
      v.result
    end
  end
end

# starts the repl for vish engine
def vepl options={}, argv:
  vm = VirtualMachine.new
  begin
    # setup arguments to vepl command as :argv
    vm.fs[:argv] = argv

    vishrc = File.dirname(File.expand_path(__FILE__)) + '/../etc/vishrc'
    if File.exist?(vishrc) && options[:no_start].nil?
      code = File.read(vishrc)
      cblock = Visher.parse! code
      vm.call cblock
    end
    # load any startup scripts
    options[:start].each do |code|
      cblock = Visher.parse! code
      vm.call cblock
    end
    # run any --execute scripts
    options[:execute].each do |code|
      cblock = Visher.parse! code
      vm.call cblock
    end

    loop do
      begin
      print vm.fs[:prompt]
      command = $stdin.gets
      fail if command.nil?
      command = command.chomp
      next if command.empty?
      block = Visher.parse! command
      vm.call block
   rescue VishSyntaxError => err
     vm.ios[:err].puts err.message
     vm.fs[:exit_status] = false
   end
     end
    
    rescue VirtualMachine::ExitCalled
      # nop

   rescue => err
      puts err.message
      puts err.backtrace[0]
      Log.say_time "Exception #{err.message}: - backtrace:"
      Log.dump err.backtrace
     puts 'Exiting ...'
   ensure
     # TODO: allow any possible future exitting events to fire
    end

    vm
end

