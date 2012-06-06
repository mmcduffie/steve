require 'helper'

class NewParserTest < Test::Unit::TestCase
  def test_shift
    parser = Steve::NewParser.new [], []
    parser.lookahead_token = Steve::Token.new "FOO", "foo", false
    parser.shift
    assert_equal [parser.lookahead_token], parser.parser_stack, "Shift did not happen as we expected."
  end
  def test_multiple_shift
    parser = Steve::NewParser.new [], []
    token_1 = Steve::Token.new "FOO", "foo", false
    token_2 = Steve::Token.new "BAR", "bar", false
    parser.lookahead_token = token_1
    parser.shift
    parser.lookahead_token = token_2
    parser.shift
    assert_equal [
      token_1,
      token_2
    ], parser.parser_stack, "Shift did not happen as we expected, parser stack needs to stay in correct order."
  end
  def test_reduce
    parser = Steve::NewParser.new [], []

    token_1 = Steve::Token.new "FOO", "foo", false
    token_2 = Steve::Token.new "FOO", "foo", false

    root_token = Steve::Token.new "ROOT", [
      token_1,
      token_2
    ], true

    parser.parser_stack = [
      token_1,
      token_2
    ]

    parser.reduce "ROOT", true
    assert_equal [root_token], parser.input_tokens, "Reduction did not happen as we expected."
  end
  def test_simple_parse
    symbol = mock
    symbol.stubs(:components).returns([["BAR","BAR"]])
    symbol.stubs(:recursive_components).returns([[]])
    symbol.stubs(:name).returns("GROUP")
    symbol.stubs(:root?).returns(true)

    token1 = Steve::Token.new "BAR", "bar", false
    token2 = Steve::Token.new "BAR", "bar", false

    root_token = Steve::Token.new "GROUP", [
      token1,
      token2
    ], true

    parser = Steve::NewParser.new [symbol], [
      token1,
      token2
    ]

    assert_equal root_token, parser.parse, "Parse did not occur properly."
  end
end
