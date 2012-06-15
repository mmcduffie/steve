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
      Steve::Token.new("foo","foo",false,[],[]),
      Steve::Token.new("foo","foo",false,[],[]),
      Steve::Token.new("bar","bar",false,[],[])
    ], tokens, "Token array returned from scan is not what we expected."
  end
  def test_complicated_scan
    tokens = @lexer.scan 'foo "foo bar"'
    assert_equal [
      Steve::Token.new("foo","foo",false,[],[]),
      Steve::Token.new("string","\"foo bar\"",false,[],[])
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
      Steve::Token.new("OPEN_OBJECT","[",false,[],[]),
      Steve::Token.new("OPEN_OBJECT","[",false,[],[]),
      Steve::Token.new("foo","foo",false,[],[]),
      Steve::Token.new("CLOSE_OBJECT","]",false,[],[]),
      Steve::Token.new("OPEN_OBJECT","[",false,[],[]),
      Steve::Token.new("CLOSE_OBJECT","]",false,[],[]),
      Steve::Token.new("CLOSE_OBJECT","]",false,[],[])
    ], tokens, "Token array returned from scan is not what we expected."
  end
  def test_lexing_error
    assert_raise SyntaxError do
      @lexer.scan "foo baz bar"
    end
  end
end
