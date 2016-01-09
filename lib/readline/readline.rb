# readline.rb - module Viper::Readline

module Viper
  class Readline
    def initialize
      @buffer = MultiLineBuffer.new
    end

    def readline
      Viper::Control.loop do |worker|
        key = worker.getch
        return @buffer.line if key == :return
        bound_p = worker.bound_proc_for key
        next if bound_p.nil?
        begin
          bound_p.call(@buffer)
        rescue BufferExceeded
          say BELL
        rescue => err
          say err.message
        end
      end
    end
  end
end
