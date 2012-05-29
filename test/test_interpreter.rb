require 'helper'

class InterpreterTest < Test::Unit::TestCase
  def test_simple_exec
    #
    # [ number : ( 5 + 5 ) ]
    #
    interpreter = Steve::Interpreter.new [
      { "name" => "ROOT", "value" => [
        { "name" => "OBJECT", "value" => [
          { "name" => "SLOT", "value" => [
            { "name" => "VARIABLE", "value" => "number", "root" => false },
            { "name" => "ASSIGN", "value" => ":", "root" => false },
            { "name" => "MATH_EXPRESSION", "value" => [
              { "name" => "NUMBER", "value" => "5", "root" => false },
              { "name" => "PLUS",   "value" => "+", "root" => false },
              { "name" => "NUMBER", "value" => "5", "root" => false }
            ], "root" => false }
          ], "root" => false }
        ], "root" => false }
      ], "root" => true }]
    interpreter.execute
    assert_equal 10, interpreter.symbol_table[0], "The program, when run, did not produce the expected result."
  end
end
