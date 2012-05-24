require 'rubygems'
require 'test/unit'

module Steve
  #
  # Symbols of the Symbol class represent non-terminal symbols
  # and the components that they can contain. Steve doesn't 
  # parse BNF grammars yet, so you have to achive a similar
  # result by creating Symbols and giving them components that
  # when matched will be grouped into non-terminals.
  #
  class Symbol
    attr_accessor :name
    attr_accessor :components
    attr_accessor :root
    def initialize(name,root)
      @name = name
      @root = root
      @components = []
    end
    def root?
      @root
    end
    def add_component(component_rules)
      @components.push component_rules
    end
  end
  #
  # Parser is a shift-reduce parser that recursively runs over
  # the tokens in the input until it reduces the input to one
  # root token that contains all others.
  #
  class Parser
    attr_accessor :parser_stack
    attr_accessor :grammar_rules
    attr_accessor :input_tokens
    def initialize(grammar_rules)
      @grammar_rules = grammar_rules
      @parser_stack = []
    end
    def reduce
      unless @input_tokens.empty?
        return @input_tokens if @input_tokens[0]["root"] == true #base case, as our goal is to reduce to one root
      end
      unless @input_tokens.empty?
        @parser_stack.push @input_tokens.slice!(0) #on each pass, we take a token from the input stack, and push it onto the parser stack
      end
      names = []
      @parser_stack.each do |token|
        names.push token["name"] #get the names of the tokens in the parser stack
      end
      @grammar_rules.each_with_index do |rule,symbol|
        rule.components.each do |component|
          if names == component #compare the names of the tokes currently in the stack to our rule components
            name = @grammar_rules[symbol].name
            root = @grammar_rules[symbol].root?
            reduced_token = { "name" => name, "value" => @parser_stack, "root" => root }
            @parser_stack = []
            @input_tokens.push reduced_token #if there is a match, put the reduced token back in
          end
        end
      end
      reduce
    end
  end
end

class ParserTest < Test::Unit::TestCase
  def test_add_component_to_symbol
    symbol = Steve::Symbol.new("FOO",false)
    assert_equal [["BAR","BAR"]], symbol.add_component(["BAR","BAR"]), "Added Symbol components not properly added."
  end
  def test_reduce
    symbol = Steve::Symbol.new("GROUP",true)
    symbol.add_component(["BAR","BAR"])
    parser = Steve::Parser.new([symbol])
    parser.input_tokens = [
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false }
    ]
    assert_equal [
      { "name" => "GROUP", "value" => [
        { "name" => "BAR", "value" => "bar", "root" => false },
        { "name" => "BAR", "value" => "bar", "root" => false }
      ], "root" => true}
    ], parser.reduce, "Reduction did not occur properly."
  end
  def test_more_complex_reduce
    root_symbol = Steve::Symbol.new("ROOT",true)
    root_symbol.add_component(["FOO","BAZ"])
    mid_symbol_1 = Steve::Symbol.new("FOO",false)
    mid_symbol_1.add_component(["BAR","BAR","BAR"])
    mid_symbol_2 = Steve::Symbol.new("BAZ",false)
    mid_symbol_2.add_component(["FIZZ","BUZZ","FIZZ"])
    term_symbol_1 = Steve::Symbol.new("BAR",false)
    term_symbol_2 = Steve::Symbol.new("FIZZ",false)
    term_symbol_3 = Steve::Symbol.new("BUZZ",false)
    parser = Steve::Parser.new([root_symbol,mid_symbol_1,mid_symbol_2,term_symbol_1,term_symbol_2,term_symbol_3])
    parser.input_tokens = [
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "BAR", "value" => "bar", "root" => false },
      { "name" => "FIZZ", "value" => "fizz", "root" => false },
      { "name" => "BUZZ", "value" => "buzz", "root" => false },
      { "name" => "FIZZ", "value" => "fizz", "root" => false }
    ]
    assert_equal [
      { "name" => "ROOT", "value" => [
        { "name" => "FOO", "value" => [
          { "name" => "BAR", "value" => "bar", "root" => false },
          { "name" => "BAR", "value" => "bar", "root" => false },
          { "name" => "BAR", "value" => "bar", "root" => false }
        ], "root" => false},
        { "name" => "BAZ", "value" => [
          { "name" => "FIZZ", "value" => "fizz", "root" => false },
          { "name" => "BUZZ", "value" => "buzz", "root" => false },
          { "name" => "FIZZ", "value" => "fizz", "root" => false }
        ], "root" => false}
      ], "root" => true}
    ], parser.reduce, "Reduction did not occur properly."
  end
end
