rem install.vsh will take its mandatory 2 arguments and cp -r the contents of arg1 to the directory listed in arg2
ac=:(expr :argc '-' 1)
eq :ac 2 || exec { perr "charm package install takes 2 mandatory arguments you supplied :{ac}"; exit }
function install_it(_, src, dst) {
   src=:(realpath :src); dst=:(realpath :dst)
   test -d :src || exec { perr "The supplied source: :{src} does not appear to be a directory"; exit }
   test -d :dst || exec { perr "The supplied destination : :{dst} does not appear to be a directory"; exit }
   echo "source is :{src} and dest is :{dst}"
   sh "cp -r :{src}/* :{dst}" || exec { "Error when trying 'cp -r :{src} :{dst}"; exit }
   }
   install_it :argv
