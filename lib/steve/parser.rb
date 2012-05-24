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
        #on each pass, we take a token from the input stack, and push it onto the parser stack
        @parser_stack.push @input_tokens.slice!(0)
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
