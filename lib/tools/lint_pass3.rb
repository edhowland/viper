# lint_pass3.rb - method lint_pass3 - Checks for excessive blank lineage

def blank?(line)
  line = line.chomp
  result = line =~ /^ +$/
  (line.empty? || !result.nil?)
end

def lint_pass3(buffer)
  blacklog = []
  count = 0
  buffer.to_s.lines.each_with_index do |l, n|
    count += 1 if blank?(l)
    blacklog << "Starting at line #{n + 1}" if count > 1
    count = 0 unless blank?(l)
  end
  blacklog
end

