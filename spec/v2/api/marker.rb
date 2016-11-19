# mark - module Mark - extends char with mark_set?, unmark

module Marked
  def marked?
    !!@marked
  end
  def mark
    @marked = true
  end
  def unmark
    @marked = false
  end
end



class NoMarkSetError < RuntimeError
end

 class Marker
   class << self
    def where(buffer)
      buffer.index {|e| e.respond_to?(:marked?) && e.marked? }
    end

    def set?(buffer)
      !buffer.index {|e| e.respond_to?(:marked?) && e.marked? }.nil?
    end
    def set(buffer)
      buffer.apply_at(buffer.position) {|e| e.extend Marked; e.mark }
    end
    def unset(buffer)
      buffer.apply_at(where(buffer)) {|e| e.respond_to?(:marked?) && e.unmark }
    end
    def copy buffer
      raise NoMarkSetError.new('Mark not set') unless set?(buffer)
      first,last = [where(buffer), buffer.position].sort
      buffer.within_s(first..last)
    end
    def cut buffer
            raise NoMarkSetError.new('Mark not set') unless set?(buffer)
      first, last = [where(buffer), buffer.position-1].sort
      buffer.slice!(first..last).join('')
    end
  end
  
 end
 
