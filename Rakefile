# Rakefile for running tests

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = './spec/*_spec.rb'
end

task default: [:test]

task :yard do
  sh 'yardoc -o ./doc'
end
