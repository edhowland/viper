# search_line_buffer.rb - class SearchLineBuffer - preloads Viper::Readline with Viper::Session[:searches]

# TODO class documentation
class SearchLineBuffer 
  def initialize 
    Viper::Session[:searches] ||= []
    # FIXME: add above searches into this buffer
    @buffer = Buffer.new Viper::Session[:searches].join("\n") + "\n"
    @buffer.fin
  end

  # interact with this @buffer, returning buffer.line when :return is pressed
  def readline
    Viper::Control.loop(search_bindings) do |worker|
    begin
      key = worker.getch
      break if key == :return
      prc = worker.bound_proc_for key
      prc.call(@buffer) unless prc.nil?
    rescue => err
      say BELL
    end
    end

    @buffer.line.chomp
  end

end

