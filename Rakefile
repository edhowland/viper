# Rakefile for running tests
#require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do|t|
  t.test_files = FileList['minitest/test_*.rb'].reject {|e| e.match(/test_helper/) }
end



import './lib/vish/compile.rake'

task :test_rb do
  sh 'ruby test/all_tests.rb'
end

task :test_vsh do
  sh './bin/viper --no-finish -m nop -s test/all_tests.vsh'
end

#task test: [:test_rb, :test_vsh]

task default: [:test]

task :yard do
  sh 'yardoc -o ./doc'
end
