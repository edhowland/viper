# searcher.rb - class Viper::Snippets::Searcher

# Viper namespace
module Viper
  # Snippets namespace for classes dealing with snippets
  module Snippets
    # Searcher  class to locate snippet path from package, ~/.viper/snippets or Viper:./config
    class Searcher
      class << self
        def packages_paths(path)
          Viper::Packages.store.map { |e| "#{e.path}/snippets/#{path}.json" }
        end

        def home_path(path)
          File.expand_path("#{Viper::Local::ROOT}/.viper/snippets/#{path}.json")
        end

        def config_path(path)
          File.expand_path(File.dirname(File.expand_path(__FILE__)) + '/../../config/' + path + '.json')
        end

        # Attempt to locate path.json in packages_path, home_path or config_path. If not found, raise RuntimeError unless opts[:ignore_missing] is true
        def locate(path, opts = {})
          result = (packages_paths(path) + [home_path(path), config_path(path)]).select { |e| File.exist?(e) }
          fail RuntimeError.new("Snippet #{path}.json could not be found in search path") if result.empty? && !opts[:ignore_missing]
          result.first
        end
      end
    end
  end
end
