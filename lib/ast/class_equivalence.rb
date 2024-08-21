# module ClassEquivalence

module ClassEquivalence
  def class_eq(other)
    other.class == self.class
  end

  def list_eq(a, b)
    (a.length == b.length) && (a.zip(b).reduce(true) {|i, j| i && (j[0] == j[1]) })
  end
end