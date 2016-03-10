# searcher.rb - class Viper::Snippets::Searcher

# TODO module documentation
module Viper
  # TODO module documentation
  module Snippets
    # TODO: class documentation
    class Searcher
      class << self

        def config_path path
          File.expand_path(File.dirname(File.expand_path(__FILE__)) + '/../../config/' + path + '.json')
        end
        def locate path
          config_path(path)
        end
      end
    end
  end
end

