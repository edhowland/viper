# lint_pass1.rb - method lint performs lint tasks on buffer (Pass 1 - Indents must be even # of spaces)

def lint_pass1(buffer)
  arr = []
  buffer.to_s.lines.each_with_index do |s, l|
    indent = s.index(/[^ ]./)

    arr << "line #{l+1}: offset: #{indent}" unless indent.nil? || indent.even?
  end
  arr
end
