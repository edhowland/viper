# readline.rb - module Viper::Readline

# TODO: Module documentation
module Viper
  # TODO: Class documentation
  class Readline
    def initialize
      @buffer = MultiLineBuffer.new
      @last_line = ''
    end

    attr_reader :last_line

    def readline
      @buffer.fin # sets up next blank line
      Viper::Control.loop do |worker|
        begin
          key = worker.getch
          break if key == :return
          bound_p = worker.bound_proc_for key
          next if bound_p.nil?
          bound_p.call(@buffer)
        rescue BufferExceeded
          say BELL
        rescue => err
          say err.message
          break
        end
      end

      result = @buffer.line
      unless result.empty?
        @last_line = @buffer.line
        @buffer.new_line
      end
      result
    end
  end
end
