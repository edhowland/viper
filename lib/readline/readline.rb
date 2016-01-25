# readline.rb - module Viper::Readline

# Style/Documentation: Enabled: false
# Metrics/LineLength: Enabled: false 
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
        key = worker.getch
        break if key == :return
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

      result = @buffer.line
      unless result.empty?
        @last_line = @buffer.line
        @buffer.new_line
      end
      return result
    end
  end
end
