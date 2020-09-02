# blankable.rb - module Blankable - adds :blank? to objects
# Ok to convert match  to TrueClass/FalseClass via double negation
# rubocop:disable Style/DoubleNegation

module Blankable
  def blank?
    case self
    when NilClass
      true
    when String
      empty? || !!match(/^\s+$/)
    else
      if respond_to?(:empty?)
        empty?
      else
        false
      end
    end
  end
end
