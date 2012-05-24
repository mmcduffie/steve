require 'helper'

class ParserTest < Test::Unit::TestCase
  def test_add_component_to_symbol
    symbol = Steve::Symbol.new("FOO",false)
    assert_equal [["BAR","BAR"]], symbol.add_component(["BAR","BAR"]), "Added Symbol components not properly added."
  end
  def test_reduce
    symbol = Steve::Symbol.new("GROUP",true)
    symbol.add_component(["BAR","BAR"])
    parser = Steve::Parser.new([symbol])
    parser.input_tokens = [
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false }
    ]
    assert_equal [
      { "name" => "GROUP", "value" => [
        { "name" => "BAR", "value" => "bar", "root" => false },
        { "name" => "BAR", "value" => "bar", "root" => false }
      ], "root" => true}
    ], parser.reduce, "Reduction did not occur properly."
  end
  def test_more_complex_reduce
    root_symbol = Steve::Symbol.new("ROOT",true)
    root_symbol.add_component(["FOO","BAZ"])
    mid_symbol_1 = Steve::Symbol.new("FOO",false)
    mid_symbol_1.add_component(["BAR","BAR","BAR"])
    mid_symbol_2 = Steve::Symbol.new("BAZ",false)
    mid_symbol_2.add_component(["FIZZ","BUZZ","FIZZ"])
    term_symbol_1 = Steve::Symbol.new("BAR",false)
    term_symbol_2 = Steve::Symbol.new("FIZZ",false)
    term_symbol_3 = Steve::Symbol.new("BUZZ",false)
    parser = Steve::Parser.new([root_symbol,mid_symbol_1,mid_symbol_2,term_symbol_1,term_symbol_2,term_symbol_3])
    parser.input_tokens = [
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "FIZZ", "value" => "fizz", "root" => false },
      { "name" => "BUZZ", "value" => "buzz", "root" => false },
      { "name" => "FIZZ", "value" => "fizz", "root" => false }
    ]
    assert_equal [
      { "name" => "ROOT", "value" => [
        { "name" => "FOO", "value" => [
          { "name" => "BAR", "value" => "bar", "root" => false },
          { "name" => "BAR", "value" => "bar", "root" => false },
          { "name" => "BAR", "value" => "bar", "root" => false }
        ], "root" => false},
        { "name" => "BAZ", "value" => [
          { "name" => "FIZZ", "value" => "fizz", "root" => false },
          { "name" => "BUZZ", "value" => "buzz", "root" => false },
          { "name" => "FIZZ", "value" => "fizz", "root" => false }
        ], "root" => false}
      ], "root" => true}
    ], parser.reduce, "Reduction did not occur properly."
  end
end
