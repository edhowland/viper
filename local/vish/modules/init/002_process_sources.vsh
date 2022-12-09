rem process_sources.vsh read in any -s sources
cond { test -z :(first :argv) } { nop } else {  src=:(first :argv); source ":{latest_wd}/:{src}" }
