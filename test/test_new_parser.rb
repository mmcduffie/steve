require 'helper'

class NewParserTest < Test::Unit::TestCase
  def test_shift
    parser = Steve::NewParser.new [], []
    parser.lookahead_token = { "name" => "FOO", "value" => "foo", "root" => false }
    parser.shift
    assert_equal [{ "name" => "FOO", "value" => "foo", "root" => false }], parser.parser_stack, "Shift did not happen as we expected."
  end
  def test_multiple_shift
    parser = Steve::NewParser.new [], []
    parser.lookahead_token = { "name" => "FOO", "value" => "foo", "root" => false }
    parser.shift
    parser.lookahead_token = { "name" => "BAR", "value" => "bar", "root" => false }
    parser.shift
    assert_equal [
      { "name" => "FOO", "value" => "foo", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false }
    ], parser.parser_stack, "Shift did not happen as we expected, parser stack needs to stay in correct order."
  end
  def test_reduce
    parser = Steve::NewParser.new [], []
    parser.parser_stack = [
      { "name" => "FOO", "value" => "foo", "root" => false },
      { "name" => "FOO", "value" => "foo", "root" => false }
    ]
    parser.reduce "ROOT", true
    assert_equal [
      { "name" => "ROOT", "value" => [
        { "name" => "FOO", "value" => "foo", "root" => false },
        { "name" => "FOO", "value" => "foo", "root" => false }
      ], "root" => true }
    ], parser.input_tokens, "Reduction did not happen as we expected."
  end
end
