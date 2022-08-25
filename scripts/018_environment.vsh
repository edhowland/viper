rem 018_environment.vsh: Helper functions for access to users OS environment
function env(var) { ruby "print ENV[':{var}']" }
HOME=:(env HOME); global HOME
XDG_CONFIG_HOME=:(env XDG_CONFIG_HOME); test -z :XDG_CONFIG_HOME && XDG_CONFIG_HOME=":{HOME}/.config"
rem Set some Vish variables
_vconfig=":{XDG_CONFIG_HOME}/vish"; global _vconfig
rem _vpm_root is the location of all Vish Package Management files
_vpm_root=":{_vconfig}/vpm"; global _vpm_root
