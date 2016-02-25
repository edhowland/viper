# config_path.rb - method config_path - returns full path to config dir

def config_path
  File.expand_path(File.dirname(File.expand_path(__FILE__)) + '../../../config') + '/'
end
