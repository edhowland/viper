# package_load.rb - method package_load - loads given package given name

def package_load name
  pkg = Viper::Package.new name
  pkg.load
end
