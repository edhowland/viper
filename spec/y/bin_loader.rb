# bin_loader.rb - creates /viper/bin in Viper::VFS - loads commands there

require_relative 'bad'
require_relative 'echo'
require_relative 'cat'
require_relative 'pry_invoker'
require_relative 'debug'
require_relative 'source'
require_relative 'bye'

bindir = Viper::VFS.mknode '/viper/bin'

bindir[:pry] = PryInvoker.new
bindir[:bye] = Bye.new
bindir[:debug] = Debug.new
bindir[:echo] = Echo.new
bindir[:cat] = Cat.new
bindir[:source] = Source.new
bindir[:bad] = Bad.new

