# tabber - module Tabber, class Tab

module Tabber
  def tabbed?
    true
  end
end

class Tab
  class << self
    def next_amt(buffer)
    offset = (buffer.at.respond_to?(:tabbed?) ? 1 : 0)
      buffer.to_a[(buffer.position + offset)..-1].index {|e| e.respond_to?(:tabbed?)  } + offset
    end
    def next_abs buffer
      buffer.position + next_amt(buffer)
    end

    def set buffer
            buffer.apply_at(buffer.position - 1) {|e| e.extend Tabber}
    end
  end
end

