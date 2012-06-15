module Steve
  class NewParser
    attr_accessor :parser_stack
    attr_accessor :input_tokens
    def initialize(grammar_rules,input_tokens)
      @grammar_rules = grammar_rules
      @input_tokens = input_tokens.reverse!
      @parser_stack = []
    end
    def shift
      unless @input_tokens.empty?
        @parser_stack.push @input_tokens.pop
      end
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
        return @input_tokens[0]
      end
      shift
      stack_with_lookahead = @parser_stack
      stack_with_lookahead.push @input_tokens.last
      lookahead_match = match stack_with_lookahead
      if lookahead_match
        shift
        reduce lookahead_match.name, lookahead_match.root
      else
        match = match @parser_stack
        if match
          reduce match.name, match.root
        end
      end
      parse
    end
  end
end
