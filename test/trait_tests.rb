# trait_tests.rb - tests for CharacterTraits

require_relative 'test_helper'



class TraitTests < BaseSpike
  def set_up
    @buf = Buffer.new ''
  end
  # create string sets @buf and positions it at beginning
  def create string
    @buf.ins string
    @buf.beg
  end
  def test_w_no_trait_set_has_returns_false
    create 'hello'
    assert_false @buf.trait_has 'm'
  end
  def test_set_trait
    create 'hello'
    @buf.trait_set 'm'
    assert @buf.trait_has 'm'
  end
  def test_trait_del
    create 'hello'
    @buf.trait_set 'm'
    @buf.trait_del 'm'
    assert_false @buf.trait_has 'm'
  end
  def test_trait_next
    create 'hello'
    @buf.fwd; @buf.fwd; @buf.fwd
    @buf.trait_set 'm'
    @buf.beg
    result = @buf.trait_next 'm'
    assert_eq result, 3
  end
  def test_trait_prev
    create 'hello'
    @buf.trait_set 'm'
    @buf.fin
    result = @buf.trait_prev 'm'
    assert_eq result, 0
  end
  def test_trait_exists
    create 'hello'
    @buf.fin
    @buf.back
    @buf.trait_set 'm'
    @buf.fin
  assert @buf.trait_exists 'm'
  end
  def test_trait_exists_w_no_trait_set
    create 'hello'
    assert_false @buf.trait_exists 'm'
  end
  def test_trait_first_w_no_trait_set_returns_0
    create 'hello'
    assert_eq @buf.trait_first('m'), 0
  end
  def test_trait_first_finds_position
    create 'hello'
    @buf.fwd; @buf.fwd
    @buf.trait_set 'm'
    @buf.fin
    assert_eq @buf.trait_first('m'), 2
  end
end