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
      reduced_token = Steve::Token.new name, @parser_stack, root, [], []
      @parser_stack = []
      @input_tokens.push reduced_token
    end
    def match(stack)
      @grammar_rules.each do |rule|
        if stack == rule.components
          return rule
        else
          return false
        end
      end
    end
    def parse
      if @input_tokens.length == 1 && @input_tokens[0].root
        return @input_tokens
      end
      # If there is no lookahead token yet, get one.
      if @lookahead_token.nil?
        @lookahead_token = @input_tokens.shift
      end
      # Create an array of tokens that includes the lookahead token.
      comparison_stack = @parser_stack
      comparison_stack.push @lookahead_token
      # Try to match using the lookahead token.
      match_result = match(comparison_stack)
      if match_result
        shift
        reduce match_result.name, match_result.root
      end
      # If no match, shift another token.
      shift
      # Recursively call parse another time.
      parse
    end
  end
end
