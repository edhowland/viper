#!/usr/bin/env ruby
# extract.rb : fn extract [list.of.lambdas], list : returns list of N lists
# where N is the number of lambdas. If no elements form original list match any
# filter, the matching list is empty

def extract(list, *lambdas)
  lambdas.map {|f| list.select(&f) }
end
