# element - module Element - sortable - one of Redirection, Glob or Assignment

module Element
  include Comparable
  def <=> other
    self.ordinal <=> other.ordinal
  end
end