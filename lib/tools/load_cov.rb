# load_cov.rb - method load_cov - loads some coverage.json created via simplecov

def load_cov(pathname)
  Viper::Session[:coverage] = JSON.load(File.read(pathname))
end
