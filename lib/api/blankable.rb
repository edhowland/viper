# blankable.rb - module Blankable - adds :blank? to objects

module Blankable
  def blank?
    case self
    when NilClass
      true
    when String
      self.empty? || !!self.match(/^\s+$/)
    else
      if self.respond_to?(:empty?)
        self.empty?
      else
        false
      end
    end
  end
end