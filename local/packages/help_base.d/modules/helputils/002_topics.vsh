function threed(dir) {
   basename :(dirname :(dirname :dir))
}
rem topics command lists contents of a topic category or just known categories
function topics(subject) {
   cond { eq :_argc 0 } {
      echo "Known topic categories"
      ifs=':' for p in :hpath {
         c=:(threed :p)
         b=:(basename :p)
         echo ":{c}: :{b}"
      }
   } else {
      ifs=':' for p in :hpath {
         (cd :p; ls *.md | grep :subject)
      }
   }
   }
   