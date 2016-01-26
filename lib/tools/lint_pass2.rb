# lint_pass2.rb - method lint_pass2

def get_indent(line)
  result = line.index(/[^ ]/)
  (result || 0)
end

# Lint Pass 2 - compare indent levels between adjacent non-empty lines
def lint_pass2(buffer)
  blacklog = []
  comparator = CompareIndent.new
  previous = 0
  buffer.to_s.lines.each_with_index do |l, n|
    unless l.chomp.empty?
      # compare previous
      indent = get_indent(l)
      result = comparator.cmp indent, previous
      blacklog << "Line #{n + 1}: indent: #{result[0]} previous #{result[1]}" unless result.nil?
    else
      indent = previous # blank lines are OK to skip
    end

    previous = indent
  end
  blacklog
end
