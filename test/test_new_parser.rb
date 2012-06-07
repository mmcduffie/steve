require 'helper'

class NewParserTest < Test::Unit::TestCase
  def test_shift
    parser = Steve::NewParser.new [], []
    test_token = Steve::Token.new "FOO", "foo", false, [], []
    parser.lookahead_token = test_token
    parser.shift
    #assert_equal [test_token], parser.parser_stack, "Shift did not happen as we expected."
  end
  def test_multiple_shift
    parser = Steve::NewParser.new [], []
    token_1 = Steve::Token.new "FOO", "foo", false, [], []
    token_2 = Steve::Token.new "BAR", "bar", false, [], []
    parser.lookahead_token = token_1
    parser.shift
    parser.lookahead_token = token_2
    parser.shift
    #assert_equal [
    #  token_1,
    #  token_2
    #], parser.parser_stack, "Shift did not happen as we expected, parser stack needs to stay in correct order."
  end
  def test_reduce
    parser = Steve::NewParser.new [], []

    token_1 = Steve::Token.new "FOO", "foo", false, [], []
    token_2 = Steve::Token.new "FOO", "foo", false, [], []

    root_token = Steve::Token.new "ROOT", [
      token_1,
      token_2
    ], true, [], []

    parser.parser_stack = [
      token_1,
      token_2
    ]

    parser.reduce "ROOT", true
    #assert_equal [root_token], parser.input_tokens, "Reduction did not happen as we expected."
  end
  def test_match
    symbol_component1 = Steve::Token.new "BAR", "bar", false, [], []
    symbol_component2 = Steve::Token.new "BAR", "bar", false, [], []

    symbol = Steve::Token.new "GROUP", "", true, [symbol_component1,symbol_component2], []

    token1 = Steve::Token.new "BAR", "bar", false, [], []
    token2 = Steve::Token.new "BAR", "bar", false, [], []

    parser_stack = [
      token1,
      token2
    ]

    parser = Steve::NewParser.new [symbol], []

    #assert_equal symbol, parser.match(parser_stack), "Match did not return the name of the matching non-terminal."
  end
  def test_simple_parse
    symbol_component1 = Steve::Token.new "BAR", "bar", false, [], []
    symbol_component2 = Steve::Token.new "BAR", "bar", false, [], []

    symbol = Steve::Token.new "GROUP", "", true, [symbol_component1,symbol_component2], []

    token1 = Steve::Token.new "BAR", "bar", false, [], []
    token2 = Steve::Token.new "BAR", "bar", false, [], []

    root_token = Steve::Token.new "GROUP", [
      token1,
      token2
    ], true, [], []

    parser = Steve::NewParser.new [symbol], [
      token1,
      token2
    ]

    assert_equal root_token, parser.parse, "Parse did not occur properly."
  end
end
