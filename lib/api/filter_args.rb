# filter_args.rb : fn filter_args *args: divides arg list into extant and extinct fs objects

# will return 2 lists: [[list of extant fs objects], [list of extinct fs objects]]
# If a '-' occurs anywhere as the single element of list, it will be treated as true
def filter_args *args
  extract(args, ->(e) { e == '-' || Hal.exist?(e) }, ->(e) { e == '-' ? false :  !Hal.exist?(e) })
end