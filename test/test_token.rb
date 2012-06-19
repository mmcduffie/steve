require 'helper'

class TokenTest < Test::Unit::TestCase
  def test_compare
    token1 = Steve::Token.new({ :name => "FOO", :value => "foo" })
    token2 = Steve::Token.new({ :name => "FOO", :value => "bar" })
    assert token1 == token2, "Comparison did not work."
  end
end
