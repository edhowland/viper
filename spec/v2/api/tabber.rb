# tabber - module Tabber, class Tab

module Tabber
  def tabbed?
    true
  end
end

class NoTabFound < RuntimeError; end

class Tab
  class << self
    def index_next_tab slice
      slice.index {|e| e.respond_to?(:tabbed?) }
    end

    def next_amt(buffer)
    offset = (buffer.at.respond_to?(:tabbed?) ? 1 : 0)
      #buffer.to_a[(buffer.position + offset)..-1].index {|e| e.respond_to?(:tabbed?)  } + offset
      result = index_next_tab buffer.to_a[(buffer.position + offset)..-1]
      raise NoTabFound.new('No tab point found found from here to end of buffer') if result.nil?
      result + offset
    end

    def next_abs buffer
      buffer.position + next_amt(buffer)
    end

    def set buffer
            buffer.apply_at(buffer.position - 1) {|e| e.extend Tabber}
    end

     def set?(buffer)
      !buffer.index {|e| e.respond_to?(:tabbed?) && e.tabbed? }.nil?
    end


    # advances buffer to next tab pt + 1. extra char so pointed at char to right
    # of current cursor position after advance
    def advance buffer
      buffer.goto_position(next_abs(buffer) + 1)
      ''
    end
  end
end

