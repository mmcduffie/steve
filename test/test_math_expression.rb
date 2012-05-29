require 'helper'

class MathExpressionTest < Test::Unit::TestCase
  def test_build_string
    exp = Steve::MathExpression.new [
      { "name" => "NUMBER", "value" => "1", "root" => false },
      { "name" => "PLUS",   "value" => "+", "root" => false },
      { "name" => "NUMBER", "value" => "1", "root" => false }
    ]
    test_string = exp.build_string
    assert_equal "1+1", test_string, "Test string is not what we expected!"
  end
  def test_eval_string
    exp = Steve::MathExpression.new [
      { "name" => "NUMBER", "value" => "5", "root" => false },
      { "name" => "PLUS",   "value" => "+", "root" => false },
      { "name" => "NUMBER", "value" => "5", "root" => false }
    ]
    test_string = exp.build_string
    assert_equal 10, exp.eval_string, "Test string is not what we expected!"
  end
end
