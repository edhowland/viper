# package_info.rb - method package_info pkg_name - compile string from Viper::Packages.store

def package_info name
  a = Viper::Packages.store.select { |e| e.name == name }
  raise Viper::Packages::PackageNotFound.new(name) if a.empty?
  package = a.first
  "Package name: #{package.name} version: #{package.version}"
end

