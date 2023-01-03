# Rakefile for running tests
require 'rake/testtask'

Rake::TestTask.new do|t|
  t.test_files = FileList['minitest/test_*.rb'].reject {|e| e.match(/test_helper/) }
end



import './lib/vish/compile.rake'


desc 'Tests Vish commands'
task :test_vsh do
  sh 'cd ./vshtest; ../bin/vish all_tests.vsh'
end
desc 'Run all tests. Including Ruby and Vish tests'
task all_tests: [:test, :test_vsh]

task default: [:all_tests]

desc 'Build documentation'
task :yard do
  sh 'yardoc -o ./doc'
end
