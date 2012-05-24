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
      { "name" => "foo", "value" => "foo", "root" => false },
      { "name" => "foo", "value" => "foo", "root" => false },
      { "name" => "bar", "value" => "bar", "root" => false }
    ], tokens, "Token array returned from scan is not what we expected."
  end
  def test_complicated_scan
    tokens = @lexer.scan 'foo "foo bar"'
    assert_equal [
      { "name" => "foo", "value" => "foo", "root" => false },
      { "name" => "string", "value" => "\"foo bar\"", "root" => false }
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
      { "name" => "OPEN_OBJECT",  "value" => "[",   "root" => false },
      { "name" => "OPEN_OBJECT",  "value" => "[",   "root" => false },
      { "name" => "foo",          "value" => "foo", "root" => false },
      { "name" => "CLOSE_OBJECT", "value" => "]",   "root" => false },
      { "name" => "OPEN_OBJECT",  "value" => "[",   "root" => false },
      { "name" => "CLOSE_OBJECT", "value" => "]",   "root" => false },
      { "name" => "CLOSE_OBJECT", "value" => "]",   "root" => false }
    ], tokens, "Token array returned from scan is not what we expected."
  end
  def test_lexing_error
    assert_raise SyntaxError do
      @lexer.scan "foo baz bar"
    end
  end
end
