require 'helper'

class ParserTest < Test::Unit::TestCase
  def test_shift
    parser = Steve::Parser.new [], []
    test_token = Steve::Token.new({ :name => "FOO", :value => "foo" })
    parser.input_tokens.push test_token
    parser.shift
    assert_equal [test_token], parser.parser_stack, "Shift did not happen as we expected."
  end
  def test_multiple_shift
    parser = Steve::Parser.new [], []
    token_1 = Steve::Token.new({ :name => "FOO", :value => "foo" })
    token_2 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    parser.input_tokens.push token_1
    parser.shift
    parser.input_tokens.push token_2
    parser.shift
    assert_equal [
      token_1,
      token_2
    ], parser.parser_stack, "Shift did not happen as we expected, parser stack needs to stay in correct order."
  end
  def test_reduce
    parser = Steve::Parser.new [], []

    token_1 = Steve::Token.new({ :name => "FOO", :value => "foo" })
    token_2 = Steve::Token.new({ :name => "FOO", :value => "foo" })

    root_token = Steve::Token.new({ :name => "ROOT" })
    root_token.value = [token_1,token_2]
    root_token.root = true

    parser.parser_stack = [token_1,token_2]

    parser.reduce "ROOT", true
    assert_equal [root_token], parser.input_tokens, "Reduction did not happen as we expected."
  end
  def test_match
    symbol_component1 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    symbol_component2 = Steve::Token.new({ :name => "BAR", :value => "bar" })

    symbol = Steve::Token.new({ :name => "GROUP", :root => true })
    symbol.rules = [[symbol_component1,symbol_component2]]

    token1 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    token2 = Steve::Token.new({ :name => "BAR", :value => "bar" })

    parser_stack = [token1,token2]

    parser = Steve::Parser.new [symbol], []

    assert_equal symbol, parser.match(parser_stack), "Match did not return the name of the matching non-terminal."
  end
  def test_another_match
    symbol_component1 = Steve::Token.new({ :name => "BAZ", :value => "baz" })
    symbol_component2 = Steve::Token.new({ :name => "BAZ", :value => "baz" })
    symbol_component3 = Steve::Token.new({ :name => "BAZ", :value => "baz" })

    symbol_1 = Steve::Token.new({ :name => "GROUP", :root => false })
    symbol_1.rules = [[symbol_component1,symbol_component2,symbol_component3]]

    symbol_component4 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    symbol_component5 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    symbol_component6 = Steve::Token.new({ :name => "FOO", :value => "foo" })

    symbol_2 = Steve::Token.new({ :name => "ROOT", :root => true })
    symbol_2.rules = [[symbol_component4,symbol_component5,symbol_component6]]

    token1 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    token2 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    token3 = Steve::Token.new({ :name => "FOO", :value => "foo" })

    parser_stack = [token1,token2,token3]

    parser = Steve::Parser.new [symbol_1,symbol_2], []

    assert_equal symbol_2, parser.match(parser_stack), "Match did not return the name of the matching non-terminal."
  end
  def test_simple_parse
    symbol_component1 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    symbol_component2 = Steve::Token.new({ :name => "BAR", :value => "bar" })

    symbol = Steve::Token.new({ :name => "GROUP", :root => true })
    symbol.rules = [[symbol_component1,symbol_component2]]

    token1 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    token2 = Steve::Token.new({ :name => "BAR", :value => "bar" })

    root_token = Steve::Token.new({ :name => "GROUP", :root => true })
    root_token.value = [token1,token2]

    parser = Steve::Parser.new [symbol], [token1,token2]

    assert_equal root_token, parser.parse, "Parse did not occur properly."
  end
  def test_parse_with_lookahead
    symbol_component1 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    symbol_component2 = Steve::Token.new({ :name => "BAR", :value => "bar" })

    symbol_1 = Steve::Token.new({ :name => "BARS", :root => false })
    symbol_1.rules = [[symbol_component1,symbol_component2]]

    symbol_component3 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    symbol_component4 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    symbol_component5 = Steve::Token.new({ :name => "FOO", :value => "foo" })

    symbol_2 = Steve::Token.new({ :name => "ROOT", :root => true })
    symbol_2.rules = [[symbol_component3,symbol_component4,symbol_component5]]

    token1 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    token2 = Steve::Token.new({ :name => "BAR", :value => "bar" })
    token3 = Steve::Token.new({ :name => "FOO", :value => "foo" })

    root_token = Steve::Token.new({ :name => "ROOT", :root => true })
    root_token.value = [token1,token2,token3]

    parser = Steve::Parser.new [symbol_1,symbol_2], [
      token1,
      token2,
      token3
    ]

    assert_equal root_token, parser.parse, "Parse did not occur properly."
  end
  def test_purge_duplicates
    token1 = Steve::Token.new({ :name => "OPEN" , :value => "["   })
    token2 = Steve::Token.new({ :name => "BAR"  , :value => "bar" })
    token3 = Steve::Token.new({ :name => "BAR"  , :value => "bar" })
    token4 = Steve::Token.new({ :name => "BAR"  , :value => "bar" })
    token5 = Steve::Token.new({ :name => "CLOSE", :value => "]"   })

    stack = [token1,token2,token3,token4,token5]
    
    multiple_token1 = Steve::Token.new({ :name => "BAR", :value => "bar", :multiples => true })

    parser = Steve::Parser.new [], []

    comparison_stack = [token1,token2,token5]

    assert_equal comparison_stack, parser.purge_duplicates(stack,multiple_token1), "Duplicates not removed."
  end
  def test_parse_with_recursive_rules
    symbol_component = Steve::Token.new({ :name => "BAR", :value => "bar" , :multiples => true })

    symbol = Steve::Token.new({ :name => "ROOT", :root => true })
    symbol.rules = [[symbol_component]]

    token = Steve::Token.new({ :name => "BAR", :value => "bar" })

    root_token = Steve::Token.new({ :name => "ROOT", :root => true })
    root_token.value = [token,token,token]

    parser = Steve::Parser.new [symbol], [
      token,
      token,
      token
    ]

    assert_equal root_token, parser.parse, "Parse did not occur properly."
  end
  def test_more_complex_parse_with_recursive_rules
    symbol_component1 = Steve::Token.new({ :name => "OPEN" , :value => "["   , :multiples => false })
    symbol_component2 = Steve::Token.new({ :name => "BAR"  , :value => "bar" , :multiples => true  })
    symbol_component3 = Steve::Token.new({ :name => "CLOSE", :value => "]"   , :multiples => false })

    symbol = Steve::Token.new({ :name => "ROOT", :root => true })
    symbol.rules = [[symbol_component1,symbol_component2,symbol_component3]]

    token1 = Steve::Token.new({ :name => "OPEN" , :value => "["   })
    token2 = Steve::Token.new({ :name => "BAR"  , :value => "bar" })
    token3 = Steve::Token.new({ :name => "BAR"  , :value => "bar" })
    token4 = Steve::Token.new({ :name => "BAR"  , :value => "bar" })
    token5 = Steve::Token.new({ :name => "CLOSE", :value => "]"   })

    root_token = Steve::Token.new({ :name => "ROOT", :root => true })
    root_token.value = [token1,token2,token3,token4,token5]

    parser = Steve::Parser.new [symbol], [
      token1,
      token2,
      token3,
      token4,
      token5
    ]

    assert_equal root_token, parser.parse, "Parse did not occur properly."
  end
  def test_really_complex_parse
    symbol_component1 = Steve::Token.new({ :name => "OPEN" , :value => "["   , :multiples => false })
    symbol_component2 = Steve::Token.new({ :name => "BAR"  , :value => "bar" , :multiples => true  })
    symbol_component3 = Steve::Token.new({ :name => "CLOSE", :value => "]"   , :multiples => false })

    symbol_component4 = Steve::Token.new({ :name => "OPEN_FOO" , :value => "("   , :multiples => false })
    symbol_component5 = Steve::Token.new({ :name => "FOO" ,      :value => "foo" , :multiples => true  })
    symbol_component6 = Steve::Token.new({ :name => "CLOSE_FOO", :value => ")"   , :multiples => false })

    symbol = Steve::Token.new({ :name => "ROOT", :root => true })
    symbol.rules = [[symbol_component1,symbol_component2,symbol_component3],
                    [symbol_component4,symbol_component5,symbol_component6]]

    token1 = Steve::Token.new({ :name => "OPEN_FOO" , :value => "("   })
    token2 = Steve::Token.new({ :name => "FOO" ,      :value => "foo" })
    token3 = Steve::Token.new({ :name => "FOO" ,      :value => "foo" })
    token4 = Steve::Token.new({ :name => "FOO" ,      :value => "foo" })
    token5 = Steve::Token.new({ :name => "CLOSE_FOO", :value => ")"   })

    root_token = Steve::Token.new({ :name => "ROOT", :root => true })
    root_token.value = [token1,token2,token3,token4,token5]

    parser = Steve::Parser.new [symbol], [
      token1,
      token2,
      token3,
      token4,
      token5
    ]

    assert_equal root_token, parser.parse, "Parse did not occur properly."
  end
end
