require 'rubygems'
require 'test/unit'

class Lexer
  attr_reader :definitions
  def initialize(definitions)
    @definitions = definitions
    @lexer_stack = []
    @result_stack = []
  end
  def scan(source_string)
    if source_string == ""
      return @result_stack
    end
    @lexer_stack.push(source_string.slice!(0)) #push one char onto stack
    test_string = ""
    @lexer_stack.each do |char| #build a string from what we have so far
      test_string << char
    end
    test_string.lstrip! # leading spaces are useless at this point.
    @definitions.each do |name,regex|
      match_status = regex =~ test_string #we get result of match as number so we can make sure it's exact
      if match_status == 0 #see if our test string matches a definition
        @result_stack.push({ name => test_string }) #if it does, it should be returned as a token
        @lexer_stack = [] #reset stack
      end
    end
    scan(source_string) #recursively call until we've scaned everything.
  end
end

class LexerTest < Test::Unit::TestCase
  def setup
    @lexer = Lexer.new({ "foo" => /foo/ , "bar" => /bar/ , "string" => /\"(\\.|[^\\"])*\"/ })
  end
  def test_scan
    tokens = @lexer.scan "foo foo bar"
    assert_equal [{ "foo" => "foo" },{ "foo" => "foo" },{ "bar" => "bar" }], tokens, "Token array returned from scan is not what we expected."
  end
  def test_complicated_scan
    tokens = @lexer.scan 'foo "foo bar"'
    assert_equal [{ "foo" => "foo" },{ "string" => "\"foo bar\"" }], tokens, "Token array returned from scan is not what we expected."
  end
end
