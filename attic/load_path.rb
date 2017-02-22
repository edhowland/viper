# load_path.rb - extends $LOAD_PATH with Viper paths
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'viper'
