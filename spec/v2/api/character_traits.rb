# character_traits.rb - module CharacterTraits 
# Base class for various traits assigned to individual characters. 
# Like marks, tab points, positional markers, etc.
# Each trait is just a symbol, so virtually infinite of them can be devised
# This  module just maintains an array of them for an individual char.

# These traits are implemented as a refinement to the String class

module CharacterTraits
  refine String do
    def traits
      @traits || @traits = Set.new
    end

    def includes_trait? trait
      traits.include? trait
    end

    def trait_append trait
      traits << trait
    end
    def remove_trait trait
      traits.delete trait
    end
  end
end

class Buffer
  using CharacterTraits

  def trait_set trait
    trait = trait.to_sym
    @b_buff[0].trait_append trait
    ''
  end

  def trait_del trait
    trait = trait.to_sym
    @b_buff[0].remove_trait trait
    ''
  end

  def trait_has trait
    trait = trait.to_sym
    @b_buff[0].includes_trait? trait
  end

  def trait_first trait
    trait =trait.to_sym
    to_a.index {|c| c.includes_trait? trait }
  end
  # must offset result by 1 to make up for starting at @b_buff[1]
  def trait_next trait
    trait =trait.to_sym
    @b_buff[1..-1].index {|c| c.includes_trait? trait } + position + 1
  end

  def trait_prev trait
    trait =trait.to_sym
    @a_buff.rindex{|c| c.includes_trait? trait } 
  end
end
