# trait_commands - classes:
# TraitSet - command trait_set :_buf trait - sets a trait called trait on pos
# TraitHas - command trait_has :_buf trait - true if char @pos has trait
# TraitDel - command trait_del :_buf trait - deletes trait @pos
# TraitFind - command trait_find :_buf trait - returns index of first found trait

class TraitSet < SingleArgBufferCommand; end
class TraitDel < SingleArgBufferCommand; end
class TraitHas < BooleanBufferCommand; end
class TraitFirst < SingleArgBufferCommand; end
class TraitNext < SingleArgBufferCommand; end
class TraitPrev < SingleArgBufferCommand; end
class TraitExists < BooleanBufferCommand; end
