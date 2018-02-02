# viper.vs - main function for Viper editor
defn preproc() { Environment() }
defn proc(e) { :e }
defn postproc(e) {
  prmpt=mkprompt('save:')
map(%e.buffers, :prmpt)
}
# The main function
defn viper() {
  env=preproc()
  env=proc(:env)
  postproc(:env)
}
viper()



