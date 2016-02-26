# compare_indent - classCompareIndent

# CompareIndent compares two lines for indentation levels. farther apart than 2 spaces.
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
    send([:eq, :gt, :lt][(indent <=> previous)], indent, previous)
  end
end
