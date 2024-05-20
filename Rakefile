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


desc 'Eliminate straggling left over binding.[pry,irb]'
task :binding do
  puts "Remove these left over binding.pry or binding.irb from the code"
  sh "rg --vimgrep binding lib minitest local vshtest bin  || echo Your code is clean of left over 'binding.pry or .irb s'"
end

desc 'Check for left over to-dos and fix-mes and remove-mes'
task :todo do
  puts "Unfinished business; Possibly pipe this into viper -i"
  sh "rg --vimgrep 'TODO|FIX|REMOVE' lib local minitest bin vshtest || echo Your code is clean of to-dos, fix-mes and remove-mes"
end

desc  'What steps to create a new Release'
task release: [:binding, :todo] do
  puts <<EOD
  Steps to create a new release:
  - Run 'rake' to run all tests, minitest and vshtest
  * Correct all problems
  * Remove any 'binding.pry' or even commented out '#binding.pry' lines
  - git status
  - git add and git.wip to snapshot current release candidate
  - git tag -a '2.x.x-rcX' -m '2.x.y.rcX snapshot'
  - git push pi : push local release candidate to Raspberry Pi
  - Environment test
    * Log in to test machine
    * cd to ~/dev/viper_testing
    * git clone -b 2.0.x.y.rc0 pi:/path/to/repos/viper
    * mv viper 2.0.x.y.rcX
    * cd 2.0.x.y.rc0
    * rbenv local 3.1.2
  - Run smoke tests: ./bin/vish -v, ./bin/ivsh, ./bin/viper
    * The last test: ./bin/viper should display the Welcome banner.
    * ./bin/charm status
    * ./bin/charm config create # To checkout your ~/.config/vish directory structure
  - Update version in lib/vish/version.rb
  - Update README.md and change version number.
  - Update Bugs.md, completed.md and wontfix.md
    * Add ## 2023-mm-dd to completed.md, and if applicable, wontfix.md
    * Move Todo, bug items from Bugs.md to completed.md or wontfix.md
  - Create Release notes in CHANGELOG.md
    * Create ## Release 2.x.x
    * Add date in 2023-mm-dd
    * Add ## New Features
    * Add ### Corrections
    * Get these from completed.md and git commit logs
    * Use '- summary title'
    * Add ###  Changes
    * Add ### Removed and deprecations (if not N/A)
  Run charm admin to update Welcome page
  - git status & git add stuff; E.g. the welcome page is in local so do at least git add ./local
  - git commit -m 'Release 2.0.x.y'
  - git tag -a '2.0.x.y' -m 'Release 2.0.x.y'
git push --follow-tags pi
  - git push --follow-tags
EOD
end



desc 'Build documentation'
task :yard do
  sh 'yardoc -o ./doc'
end
