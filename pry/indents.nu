#!/usr/bin/env nu
# report the indents on each line of the source file argument as well as the first word


# Reports the indent length of each line passed in the pipe
def  indent-level  [] {
each {|it| $it | split row -r '[#_@\$a-zA-Z]+' | get 0 | str length }
}



# Returns a list with ['<blank>'] if list on input is empty
def add-blank [] {
  if ($in | is-empty) { ['<blank>'] } else { $in } 
}

# Captures only the first word of the line
def word0 [] {
  each {|it| $it | split row -r '\s+' | filter {|s| $s | is-not-empty } | add-blank | get 0 }
}

# Opens a file and converts it into structured lines for further processing
def read-lines [p: path] {
  open $p | lines
}



# combine zipped tuples into records
def merge-rows [] {
  each {|it| {indent: $it.0, token0: $it.1} }
}


# Gives a combinded report of the indent level and the first non-blank token of every line of a file.
# Pay attention to odd number indentation numbers.
def main [
    sfile: string,
    --range (-r): range
    ] {
  if ($range | is-not-empty) {
    read-lines  $sfile | indent-level | zip { read-lines $sfile | word0 } | merge-rows |  range $range | table -t none
  } else {
    read-lines  $sfile | indent-level | zip { read-lines $sfile | word0 } | merge-rows |  table -t none
  }

}
