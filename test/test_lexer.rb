require 'helper'

class LexerTest < Test::Unit::TestCase
  def setup
    @lexer = Steve::Lexer.new([
      { "name" => "foo", "regex" => /foo/, "root" => false },
      { "name" => "bar", "regex" => /bar/, "root" => false },
      { "name" => "string", "regex" => /\"(\\.|[^\\"])*\"/, "root" => false }
    ])
  end
  def test_scan
    tokens = @lexer.scan "foo foo bar"
    assert_equal [
      Steve::Token.new({ :name => "foo", :value => "foo"}),
      Steve::Token.new({ :name => "foo", :value => "foo"}),
      Steve::Token.new({ :name => "bar", :value => "bar"})
    ], tokens, "Token array returned from scan is not what we expected."
  end
  def test_complicated_scan
    tokens = @lexer.scan 'foo "foo bar"'
    assert_equal [
      Steve::Token.new({ :name => "foo", :value => "foo"}),
      Steve::Token.new({ :name => "string", :value => "\"foo bar\""})
    ], tokens, "Token array returned from scan is not what we expected."
  end
  def test_single_char_tokens
    @lexer = Steve::Lexer.new([
      { "name" => "OPEN_OBJECT", "regex" => /\[/, "root" => false },
      { "name" => "foo", "regex" => /foo/, "root" => false },
      { "name" => "CLOSE_OBJECT", "regex" => /\]/, "root" => false }
    ])
    tokens = @lexer.scan "[[foo] [ ] ]"
    assert_equal [
      Steve::Token.new({ :name => "OPEN_OBJECT", :value => "["}),
      Steve::Token.new({ :name => "OPEN_OBJECT", :value => "["}),
      Steve::Token.new({ :name => "foo", :value => "foo"}),
      Steve::Token.new({ :name => "CLOSE_OBJECT", :value => "]"}),
      Steve::Token.new({ :name => "OPEN_OBJECT", :value => "["}),
      Steve::Token.new({ :name => "CLOSE_OBJECT", :value => "]"}),
      Steve::Token.new({ :name => "CLOSE_OBJECT", :value => "]"})
    ], tokens, "Token array returned from scan is not what we expected."
  end
  def test_lexing_error
    assert_raise SyntaxError do
      @lexer.scan "foo baz bar"
    end
  end
end
