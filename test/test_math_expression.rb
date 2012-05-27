require 'helper'

class MathExpression
  attr_accessor :input_tokens
  attr_accessor :output_string
  def initialize(input_tokens)
    @input_tokens = input_tokens
    @output_string = ""
  end
  def build_string
    @input_tokens.each do |token|
      @output_string << token['value']
    end
    return @output_string
  end
  def eval_string
    return @output_string.eval
  end
end

class MathExpressionTest < Test::Unit::TestCase
  def test_build_string
    exp = MathExpression.new [
      { "name" => "NUMBER", "value" => "1", "root" => false },
      { "name" => "PLUS",   "value" => "+", "root" => false },
      { "name" => "NUMBER", "value" => "1", "root" => false }
    ]
    test_string = exp.build_string
    assert_equal "1+1", test_string, "Test string is not what we expected!"
  end
  def test_eval_string
    exp = MathExpression.new [
      { "name" => "NUMBER", "value" => "5", "root" => false },
      { "name" => "PLUS",   "value" => "+", "root" => false },
      { "name" => "NUMBER", "value" => "5", "root" => false }
    ]
    test_string = exp.build_string
    assert_equal 10, exp.eval_string, "Test string is not what we expected!"
  end
end
