rem full.vsh - test for option parser
global __FILE__
mkboolopts x d
mkvalopts s f
parseopts
echo The boolean options are
for o in -d -x { name=:(optof :o); echo -n  ":{name}"; getboolopt :o; echo  }
echo the values of each value opt are
for v in -f -s { name=:(optof :v); echo -n  ":{name} "; getvalopt :v; echo  }
echo The remaining args are
echo :argv
