require 'helper'

class SymbolTest < Test::Unit::TestCase
  def test_add_component_to_symbol
    symbol = Steve::Symbol.new("FOO",false)
    assert_equal [["BAR","BAR"]], symbol.add_component(["BAR","BAR"]), "Added Symbol components not properly added."
  end
  def test_add_recursive_component_to_symbol
    symbol = Steve::Symbol.new("FOO",false)
    assert_equal [["FOO"]], symbol.add_recursive_component(["FOO"]), "Added Symbol components not properly added."
  end
end
