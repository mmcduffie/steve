require 'rubygems'
require 'test/unit'

module Steve
  class Symbol
    attr_accessor :name
    attr_accessor :components
    def initialize(name)
      @name = name
      @components = []
    end
    def add_component(component_rules)
      @components.push component_rules
    end
  end
end

class ParserTest < Test::Unit::TestCase
  def test_add_component_to_symbol
    symbol = Steve::Symbol.new("FOO")
    assert_equal [["BAR","BAR"]], symbol.add_component(["BAR","BAR"]), "Added Symbol components not properly added."
  end
end
