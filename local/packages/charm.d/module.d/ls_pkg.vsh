rem ls the ls subcommand of the charm module command Lists known modules that can be imported with the import Vish command
echo Known modules located in mpath
ifs=":" for p in :old_mpath {
   echo :p ':'
   (cd :p; ls)
}
