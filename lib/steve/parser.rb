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
      reduced_token = Steve::Token.new({ :name => name, :value => @parser_stack, :root => root })
      @parser_stack = []
      @input_tokens.push reduced_token
    end
    def match(stack)
      @grammar_rules.each do |rule|
        multiple_tokens = []
        rule.components.each do |component|
          multiple_tokens.push component if component.multiples
        end
        #stack = purge_duplicates stack, multiple_tokens
        if stack == rule.components
          return rule
        end
      end
      return false
    end
    def purge_duplicates(stack,multiple_tokens)

      # 1.) loop through entire stack seeing if current token matches the next one and one in the multiple_tokens list.
      # 2.) if no current token matches the next one and one in the multiple_tokens list, return.
      # 3.) loop through entire stack seeing if current token matches the next one and one in the multiple_tokens list.
      # 4.) if a the token matches the next one and one in the multiple_tokens list, remove that token. 
      # 5.) call this method again.

      return stack
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
    #
    # This is what the parser returns.
    #
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
      match = match @parser_stack
      if match
        unless lookahead_match?
          reduce match.name, match.root
        end
      end
      parse
    end
  end
end
