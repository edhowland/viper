# lint_pass1.rb - method lint performs lint tasks on buffer (Pass 1 - Indents must be even # of spaces)

def lint_pass1 buffer
  arr = []
  buffer.to_s.lines.each_with_index do |s, l|
    indent = s.index(/[^ ]./)
    unless indent.nil?
      arr << "line #{l+1}: offset: #{indent}" if indent.odd?
    end
  end
  arr
end
