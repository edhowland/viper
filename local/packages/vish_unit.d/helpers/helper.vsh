# helper.vsh -because no one can name things in computer science
# DO NOT name this test_helper.vsh as it will be confused with real test_*.vsh test files
cmdlet slice_of '{ f,l = args[0..1].map(&:to_i); src = (args[2] == "-" ? inp.read.chomp : args[2]); out.puts src[(f)..(l)] }'

source ":{pdir}/helpers/glob_helper.vsh"
source ":{pdir}/helpers/viper_helper.vsh"
