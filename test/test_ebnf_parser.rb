require 'helper'

class EBNFParserTest < Test::Unit::TestCase
  def test_creation
    assert_equal "Steve::EBNFParser", Steve::EBNFParser.new.class.inspect, "Did not create subclass correctly and without requiring arguments."
  end
end
