rem test subcommand of charm package sets lpath and then sources its fourth arg
tname=:(cadddr :argv)
lpath=:pwd
source :tname
