rem helper functions for help commands
function hlp_file(topic) { echo ":{topic}.md" }
rem Base command for help subsystem searches for topic that might be found in :hpath
function help(topic) {
   echo you are searching for :topic in topics found in :hpath
   hfile=:(hlp_file :topic)
   echo will try to find :hfile
   ifs=':' for h in :hpath {
      hloc=":{h}/:{hfile}"
      test -f :hloc && exec { cat :hloc; return true }
   }
   perr "No help topic can be found for :{topic}"
   return false
}
