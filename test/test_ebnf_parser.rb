require 'helper'

class EBNFParserTest < Test::Unit::TestCase
  def test_creation
    assert_equal "Steve::EBNFParser", Steve::EBNFParser.new.class.inspect, "Did not create subclass correctly and without requiring arguments."
  end
  def test_simple_parse
    parser = Steve::EBNFParser.new

    token1 = Steve::Token.new({ :name => "STRING",            :value => "foo" })
    token2 = Steve::Token.new({ :name => "END_GROUPING_NAME", :value => ":" })
    token3 = Steve::Token.new({ :name => "STRING",            :value => "foo" })
    token4 = Steve::Token.new({ :name => "OR",                :value => "|" })
    token5 = Steve::Token.new({ :name => "STRING",            :value => "STRING" })
    token6 = Steve::Token.new({ :name => "END_RULES",         :value => ";" })
    parser.input_tokens = [token1,token2,token3,token4,token5,token6]

    assert_equal "GRAMMAR", parser.parse.name, "Parser should have reduced to a single token called GRAMMAR"
  end
  def test_parse_with_mutiple_groupings
    parser = Steve::EBNFParser.new

    token1 =  Steve::Token.new({ :name => "STRING",            :value => "foo" })
    token2 =  Steve::Token.new({ :name => "END_GROUPING_NAME", :value => ":" })
    token3 =  Steve::Token.new({ :name => "STRING",            :value => "foo" })
    token4 =  Steve::Token.new({ :name => "OR",                :value => "|" })
    token5 =  Steve::Token.new({ :name => "STRING",            :value => "STRING" })
    token6 =  Steve::Token.new({ :name => "END_RULES",         :value => ";" })
    token7 =  Steve::Token.new({ :name => "STRING",            :value => "bar" })
    token8 =  Steve::Token.new({ :name => "END_GROUPING_NAME", :value => ":" })
    token9 =  Steve::Token.new({ :name => "STRING",            :value => "bar" })
    token10 = Steve::Token.new({ :name => "OR",                :value => "|" })
    token11 = Steve::Token.new({ :name => "STRING",            :value => "STRING" })
    token12 = Steve::Token.new({ :name => "END_RULES",         :value => ";" })
    parser.input_tokens = [
      token1,
      token2,
      token3,
      token4,
      token5, 
      token6,
      token7,
      token8,
      token9,
      token10,
      token11,
      token12
    ]

    #parser.debug_parse(30)
  end
end
