# vishrc_files.rb - method vishrc_files - returns .vishrc files in ~, .

def vishrc_files
  Dir[ENV['HOME'] + '/.vishrc'] + Dir['./.vishrc']
end

  
