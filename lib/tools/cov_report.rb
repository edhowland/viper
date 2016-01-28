# cov_report.rb - method cov_report
# sorts coverage.json from least covered to most covered by file

def cov_report
  raise CoverageJSONNotLoaded  if Viper::Session[:coverage].nil?

  files = Viper::Session[:coverage]['files']
#binding.pry # REMOVEME
  result = files.each_with_object([]) do |e, a|
    a << [e['filename'], e['covered_percent']]
  end
  result.sort! {|a, b| a[1] <=> b[1] }
  # get scratch bufferand format the output there
  sc = ScratchBuffer.new
  sc.name = "Coverage Report for #{Time.now.to_s}"
  result.each {|e| sc.ins "#{path_shortener(e[0])}: #{e[1]}\n"}
  sc.beg
  $buffer_ring.unshift sc
end
