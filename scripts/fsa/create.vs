# create.vs - creates new fsa
defn create() {
  ~{ mktrans(start:, key_q:, exit:, ->(e) { :e })}
  }
