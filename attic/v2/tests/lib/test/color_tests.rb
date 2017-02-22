# color_tests.rb - tests for color transforms
# blue & blue = blue
# green & blue = green
# green & green = green
# green & yellow = yellow
# yellow & yellow = yellow
# red & ANY = red
require_relative '../spike_load'

class ColorTests < BaseSpike
  def set_up
    @colors = {red: 0b000,
    yellow: 0b001,
    green: 0b011,
    blue: 0b111 }
        @fun = xform_color @colors
  end
  def test_red_and_red_is_red
    assert_eq(@fun.call(:red, :red), :red)
  end
  def test_red_and_yellow_is_red
    assert_eq(@fun.call(:red, :yellow), :red)
  end
  def test_yellow_yellow_is_yellow
    assert_eq(@fun.call(:yellow,  :yellow), :yellow)
  end
  def test_yellow_and_green_is_yellow
    assert_eq(@fun.call(:yellow, :green), :yellow)
  end
  def test_green_and_green_is_green
    assert_eq(@fun.call(:green, :green), :green)
  end
  def test_green_and_red_is_red
    assert_eq(@fun.call(:green, :red), :red)
  end
  def test_blue_and_blue_is_blue
    assert_eq(@fun.call(:blue, :blue), :blue)
  end
  def test_blue_and_green_is_green
    assert_eq(@fun.call(:blue, :green), :green)
  end
  def test_blue_and_yellow_is_yellow
    assert_eq(@fun.call(:blue, :yellow), :yellow)
  end
  def test_blue_and_red_is_red
    assert_eq(@fun.call(:blue, :red), :red)
  end
  
  # test reduce on some collections
  def test_empty_collection_is_blue
    coll = []
    assert_eq(coll.reduce(:blue, &@fun), :blue)
  end
  def test_some_greens_are_green
    coll = [:green, :green, :green]
    assert_eq(coll.reduce(:blue, &@fun), :green)
  end
  def test_some_yellows_are_yellow
    coll = [:green, :yellow, :green, :yellow, :green]
    assert_eq(coll.reduce(:blue, &@fun), :yellow)
  end
  def test_some_reds_yellows_and_greens_are_red
    coll = [:green, :yellow, :green, :red, :yellow]
    assert_eq(coll.reduce(:blue, &@fun), :red)
  end
end
