rem user_vishrc.vsh does the user have a home .config/vish/rc file
if_file ":{chome}/rc" "You already have a local Vish init file  in your  :{chome}/rc file" "There is no local .Vish init  file in your  :{chome} directory. It can be created with charm config vishrc which create one from a template"
echo
