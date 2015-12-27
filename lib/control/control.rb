# control.rb - module Viper::Control

module Viper
  class Control
    def self.loop &blk
      this = self.new
      exception_raised = false
      until exception_raised do
        begin
          yield this
        rescue => err
          exception_raised = true
        end
      end
    end

    def getch
      map_key(key_press)
    end

    def perform key, buffer
      puts key
    end
  end
end
