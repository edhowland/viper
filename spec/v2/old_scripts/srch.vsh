function bell() { ruby 'print "\a"' }
function srch(pat) { find . line &(a) { loc=:(dirname :a); global loc; grep :pat < :a > /dev/null && cd :loc && break }; grep :pat < line || ruby 'print "\a"' }
