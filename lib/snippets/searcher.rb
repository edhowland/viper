# searcher.rb - class Viper::Snippets::Searcher

# TODO module documentation
module Viper
  # TODO module documentation
  module Snippets
    # TODO: class documentation
    class Searcher
      class << self

        def home_path path
          File.expand_path("~/.viper/snippets/#{path}.json")
        end

        def config_path path
          File.expand_path(File.dirname(File.expand_path(__FILE__)) + '/../../config/' + path + '.json')
        end
        def locate path
          result = [home_path(path), config_path(path)].select { |e| File.exist?(e) }
          raise RuntimeError.new("Snippet #{path}.json could not be found in search path") if result.empty?
          result.first
        end
      end
    end
  end
end

