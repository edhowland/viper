# assoc_cascade.rb - method assoc_cascade - associates a snippet collection with default or file extension

def assoc_cascade ext, cascade
  $snippet_associations[ext] = cascade
end
