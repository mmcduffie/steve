require 'helper'

class TokenTest < Test::Unit::TestCase
  def test_compare
    token1 = Steve::Token.new("FOO","foo",false)
    token2 = Steve::Token.new("FOO","bar",false)
    assert token1 == token2, "Comparison did not work."
  end
end
