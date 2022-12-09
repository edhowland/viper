rem full.vsh - test for option parser
global __FILE__
mkboolopts x d
mkvalopts s f
parseopts
function booloptstr(o) {
  cond { getboolopt :o } { echo -n " : true" } else { echo -n " : false" }
}
echo The actual supplied boolean options are
for o in -d -x { name=:(optof :o); echo -n  ":{name}"; booloptstr :o; echo  }
echo the values of each value opt are
for v in -f -s { name=:(optof :v); echo -n  ":{name} "; getvalopt :v; echo  }
echo The remaining args are
echo :argv
