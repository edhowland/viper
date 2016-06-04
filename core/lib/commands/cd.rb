# cd.rb - command _cd path - changes directory to new path
# _cd to disambiguate from builtin cd

def _cd path
  FileUtils.cd path
end

