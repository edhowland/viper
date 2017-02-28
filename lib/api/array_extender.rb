# array_extender - module ArrayExtender

module ArrayExtender
  def to_s
    self.join('')
  end
  def count_nl
    my_index = self.to_s.index("\n")
    my_index || length
  end

  def rcount_nl
    my_index = self.to_s.rindex("\n") || 0
    self.length - my_index
  end

  def lines
    StringIO.new(self.to_s).each_line.to_a
  end

  def count_nl
    index = self.to_s.index("\n")
    index || length
  end

  def calc_range(limit)
    (limit < 0 ? limit..-1 : 0..(limit - 1))
  end

  def copy(limit)
    self[calc_range(limit)].join('')
  end

  def cut(limit)
    value = copy(limit)
    if limit >= 0
      self.slice!(0..(limit - 1))
    else
      self.slice!(limit..-1)
    end
    value
  end

  def last_line
    return '' if self[-1] == "\n"
    return self.to_s if rcount_nl == length
    self[-(rcount_nl - 1)..-1].join('')
  end

  def first_line
    self[0..(count_nl)].join('')
  end

  def rword_index
    offset = self.to_s.rindex(/\s|\n/)
    offset = self.to_s.rindex(/^\w/) if offset.nil?
    (offset.nil? ? '' : self[offset..-1].join('').lstrip)
  end

end
