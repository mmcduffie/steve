module Steve
  class NewParser
    attr_accessor :parser_stack
    attr_accessor :lookahead_token
    attr_accessor :input_tokens
    def initialize(grammar_rules,input_tokens)
      @grammar_rules = grammar_rules
      @input_tokens = input_tokens
      @parser_stack = []
    end
    def shift
      @parser_stack.push @lookahead_token
    end
    def reduce(name,root)
      reduced_token = { "name" => name, "value" => @parser_stack, "root" => root }
      @parser_stack = []
      @input_tokens.push reduced_token
    end
  end
end
