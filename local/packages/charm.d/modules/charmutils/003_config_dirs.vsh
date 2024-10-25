# config_dirs.vsh function to populate HOME/.config/vish
function populate_chome() {
   mkdir :chome
   for d in packages plugins {
      mkdir ":{chome}/:{d}"
   }
   cp ":{lhome}/packages/charm.d//config.d/templates/home_vishrc" ":{chome}/rc"
}
