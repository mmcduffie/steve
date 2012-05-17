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
    def initialize(name)
      @name = name
      @components = []
    end
    def add_component(component_rules)
      @components.push component_rules
    end
  end
  #
  #
  #
  class Parser
    attr_accessor :parser_stack
    attr_accessor :grammar_rules
    attr_accessor :input_tokens
    def initialize(grammar_rules)
      @grammar_rules = grammar_rules
      @parser_stack = []
      @temp_counter = 0
    end
    def reduce
      return if @temp_counter == 2
      @temp_counter = @temp_counter + 1
      @parser_stack.push @input_tokens.pop #on each pass, we take a token from the input stack, and push it onto the parser stack
      names = []
      @parser_stack.each do |token|
        names.push token.keys[0] #get the names of the tokens in the parser stack
      end
      @grammar_rules.each do |rule|
        rule.components.each do |component|
          if names == component #compare the names of the tokes currently in the stack to our rule components
            puts "reduce!"
          end
        end
      end
      reduce
    end
  end
end

class ParserTest < Test::Unit::TestCase
  def test_add_component_to_symbol
    symbol = Steve::Symbol.new("FOO")
    assert_equal [["BAR","BAR"]], symbol.add_component(["BAR","BAR"]), "Added Symbol components not properly added."
  end
  def test_reduce
    symbol = Steve::Symbol.new("GROUP")
    symbol.add_component(["BAR","BAR"])
    parser = Steve::Parser.new([symbol])
    parser.input_tokens = [{ "BAR" => "bar" },{ "BAR" => "bar" }]
    parser.reduce
  end
end
