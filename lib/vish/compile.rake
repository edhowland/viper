# compile.rake - Rake  task :compile for vish.kpeg to vish.kpeg.rb


file './lib/vish/vish.kpeg.rb' => './lib/vish/vish.kpeg' do
  Dir.chdir('./lib/vish') do
    sh 'kpeg -f vish.kpeg'
    sh 'sleep 2'
    sh 'ruby -c vish.kpeg.rb'
  end
end


task :compile => './lib/vish/vish.kpeg.rb'
