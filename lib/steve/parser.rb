module Steve
  class Parser
    attr_accessor :parser_stack
    attr_accessor :input_tokens
    attr_accessor :recursive_mode
    attr_accessor :lookahead_token
    attr_accessor :recursive_token
    def initialize(grammar_rules,input_tokens)
      @grammar_rules = grammar_rules
      @input_tokens = input_tokens.reverse!
      @parser_stack = []
      @recursive_mode = false
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
        end
      end
      return false
    end
    def finished?
      if @input_tokens.length == 1 && @input_tokens[0].root
        return true
      else
        return false
      end
    end
    def lookahead_match?
      lookahead_match = false
      unless @input_tokens.empty?
        @lookahead_token = @input_tokens.last
        lookahead_stack = @parser_stack + [@lookahead_token]
        lookahead_match = match lookahead_stack
      end
      return lookahead_match
    end
    def recursive_component
      @grammar_rules.each do |rule|
        if @parser_stack.last == rule.recursive_components[0]
          return rule
        end
      end
      return false
    end
    def abstract_syntax_tree
      return @input_tokens[0]
    end
    #
    # The parse method is a LR(1) shift-reduce parser.
    #
    def parse
      if finished?
        return abstract_syntax_tree
      end
      shift
      @recursive_token = recursive_component
      if recursive_component
        @recursive_mode = true
      end
      if @recursive_mode
        if @recursive_token
          if @lookahead_token != @recursive_token || @input_tokens.empty?
            reduce @recursive_token.name, @recursive_token.root
          end
        end
      else
        match = match @parser_stack
        if match
          unless lookahead_match?
            reduce match.name, match.root
          end
        end
      end
      parse
    end
  end
end
