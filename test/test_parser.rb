require 'helper'

class ParserTest < Test::Unit::TestCase
  def test_reduce
    symbol = mock
    symbol.stubs(:components).returns([["BAR","BAR"]])
    symbol.stubs(:recursive_components).returns([[]])
    symbol.stubs(:name).returns("GROUP")
    symbol.stubs(:root?).returns(true)
    parser = Steve::Parser.new([symbol])
    parser.input_tokens = [
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false }
    ]
    assert_equal [
      { "name" => "GROUP", "value" => [
        { "name" => "BAR", "value" => "bar", "root" => false },
        { "name" => "BAR", "value" => "bar", "root" => false }
      ], "root" => true }
    ], parser.reduce, "Reduction did not occur properly."
  end
  def test_more_complex_reduce

    root_symbol = mock
    root_symbol.stubs(:components).returns([["FOO","BAZ"]])
    root_symbol.stubs(:recursive_components).returns([[]])
    root_symbol.stubs(:name).returns("ROOT")
    root_symbol.stubs(:root?).returns(true)

    mid_symbol_1 = mock
    mid_symbol_1.stubs(:components).returns([["BAR","BAR","BAR"]])
    mid_symbol_1.stubs(:recursive_components).returns([[]])
    mid_symbol_1.stubs(:name).returns("FOO")
    mid_symbol_1.stubs(:root?).returns(false)

    mid_symbol_2 = mock
    mid_symbol_2.stubs(:components).returns([["FIZZ","BUZZ","FIZZ"]])
    mid_symbol_2.stubs(:recursive_components).returns([[]])
    mid_symbol_2.stubs(:name).returns("BAZ")
    mid_symbol_2.stubs(:root?).returns(false)

    term_symbol_1 = mock
    term_symbol_1.stubs(:components).returns([[]])
    term_symbol_1.stubs(:recursive_components).returns([[]])
    term_symbol_1.stubs(:name).returns("BAR")
    term_symbol_1.stubs(:root?).returns(false)

    term_symbol_2 = mock
    term_symbol_2.stubs(:components).returns([[]])
    term_symbol_2.stubs(:recursive_components).returns([[]])
    term_symbol_2.stubs(:name).returns("FIZZ")
    term_symbol_2.stubs(:root?).returns(false)

    term_symbol_3 = mock
    term_symbol_3.stubs(:components).returns([[]])
    term_symbol_3.stubs(:recursive_components).returns([[]])
    term_symbol_3.stubs(:name).returns("BUZZ")
    term_symbol_3.stubs(:root?).returns(false)

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
        ], "root" => false },
        { "name" => "BAZ", "value" => [
          { "name" => "FIZZ", "value" => "fizz", "root" => false },
          { "name" => "BUZZ", "value" => "buzz", "root" => false },
          { "name" => "FIZZ", "value" => "fizz", "root" => false }
        ], "root" => false }
      ], "root" => true }
    ], parser.reduce, "Reduction did not occur properly."
  end
  def test_recursive_reduce

    root_symbol = mock
    root_symbol.stubs(:components).returns([[]])
    root_symbol.stubs(:recursive_components).returns([["FOO"]])
    root_symbol.stubs(:name).returns("ROOT")
    root_symbol.stubs(:root?).returns(true)

    recursive_symbol = mock
    recursive_symbol.stubs(:components).returns([["BAR","BAR"]])
    recursive_symbol.stubs(:recursive_components).returns([[]])
    recursive_symbol.stubs(:name).returns("FOO")
    recursive_symbol.stubs(:root?).returns(false)

    non_recursive_symbol = mock
    non_recursive_symbol.stubs(:components).returns([[]])
    non_recursive_symbol.stubs(:recursive_components).returns([[]])
    non_recursive_symbol.stubs(:name).returns("BAR")
    non_recursive_symbol.stubs(:root?).returns(false)

    parser = Steve::Parser.new([root_symbol,recursive_symbol,non_recursive_symbol])
    parser.input_tokens = [
      { "name" => "FOO", "value" => "foo", "root" => false },
      { "name" => "FOO", "value" => "foo", "root" => false },
      { "name" => "FOO", "value" => "foo", "root" => false },
      { "name" => "FOO", "value" => "foo", "root" => false },
      { "name" => "FOO", "value" => "foo", "root" => false },
      { "name" => "FOO", "value" => "foo", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false }
    ]
    #assert_equal [
    #  { "name" => "ROOT", "value" => [
    #    { "name" => "FOO", "value" => "foo", "root" => false },
    #    { "name" => "FOO", "value" => "foo", "root" => false },
    #    { "name" => "FOO", "value" => "foo", "root" => false },
    #    { "name" => "FOO", "value" => "foo", "root" => false },
    #    { "name" => "FOO", "value" => "foo", "root" => false },
    #    { "name" => "FOO", "value" => [
    #      { "name" => "BAR", "value" => "bar", "root" => false },
    #      { "name" => "BAR", "value" => "bar", "root" => false }
    #    ], "root" => false }
    #  ], "root" => true }
    #], parser.reduce, "Reduction did not occur properly."
  end
end
