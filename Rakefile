# Rakefile for running tests

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = './spec/*_spec.rb'
end

task default: [:test]

desc 'Compile viper executable'
task :build do
  sh 'vishc -R -i env.rb -i viper_api.rb -o viper -l a1.vs -l normal.vs -l commander.vs viper.vs'
end

task :yard do
  sh 'yardoc -o ./doc'
end
