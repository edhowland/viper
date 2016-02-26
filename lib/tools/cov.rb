# cov.rb - method cov - load results for given pathname into buffer from JSON loaded via load_cov

# CoverageJSONNotLoaded raised when JSON coverage file was not loaded.
class CoverageJSONNotLoaded < RuntimeError
end

# FileNotReportedInCoverage raised when a the cov command was asked for on a FileBuffer that was not covered in coverage report JSON.
class FileNotReportedInCoverage < RuntimeError
  def initialize(fname)
    super "File #{fname} was not checked for coverage"
  end
end

def cov(buffer, pathname)
  fail CoverageJSONNotLoaded if Viper::Session[:coverage].nil?
  # expand_path of pathname
  expanded = File.expand_path(pathname)
  report = Viper::Session[:coverage]['files'].select { |e| e['filename'] == expanded }
  fail FileNotReportedInCoverage.new(expanded) if report.empty?

  buffer.ins "Coverage: #{report[0]['covered_percent']}\n"
  report[0]['coverage'].each_with_index do |e, n|
    buffer.ins "line #{n + 1}: hits: #{e}\n" unless e.nil?
  end
end
