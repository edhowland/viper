# cov_report.rb - method cov_report
# sorts coverage.json from least covered to most covered by file

def cov_header timestamp, metrics_h
  now = Time.at(timestamp)
  <<-EOP
Created: #{now}
Total Coverage: #{metrics_h['covered_percent']}
Strength: #{metrics_h['covered_strength']}
Covered lines: #{metrics_h['covered_lines']}
Total lines: #{metrics_h['total_lines']}
EOP
end

def cov_report
  raise CoverageJSONNotLoaded  if Viper::Session[:coverage].nil?
  coverage = Viper::Session[:coverage]

  files = coverage['files']
  result = files.each_with_object([]) do |e, a|
    a << [e['filename'], e['covered_percent']]
  end
  result.sort! {|a, b| a[1] <=> b[1] }
  # get scratch bufferand format the output there
  sc = ScratchBuffer.new
  sc.name = "Coverage Report"
  sc.ins(cov_header(coverage['timestamp'], coverage['metrics']))
  result.each {|e| sc.ins "#{path_shortener(e[0])}: #{e[1]}\n"}
  sc.beg
  $buffer_ring.unshift sc
end
