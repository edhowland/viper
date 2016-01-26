# compare_indent - classCompareIndent

# TODO: Class documentation
class CompareIndent
  def lt(indent, previous)
    return [indent, previous] if indent < (previous - 2)
  end

  def gt(indent, previous)
    return [indent, previous] if indent > previous + 2
  end

  def eq(_indent, _previous)
    nil
  end

  def cmp(indent, previous)
    self.send([:eq, :gt, :lt][(indent <=> previous)], indent, previous)
  end
end
