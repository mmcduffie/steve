module Steve
  class Parser
    attr_accessor :parser_stack
    attr_accessor :input_tokens
    attr_accessor :recursive_mode
    attr_accessor :lookahead_token
    attr_accessor :recursive_token
    attr_accessor :working_stack
    attr_accessor :token_count
    def initialize(grammar_rules,input_tokens)
      @grammar_rules = grammar_rules
      @input_tokens = input_tokens.reverse!
      @parser_stack = []
      @recursive_mode = false
      @working_stack = []
      @token_count = 0
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
      @grammar_rules.each do |production|
        production.rules.each do |rule|
          multiple_tokens = []
          rule.each do |token|
            multiple_tokens.push token if token.multiples
          end
          if multiple_tokens.length > 0
            multiple_tokens.each do |multiple_token|
              stack_copy = Array.new(stack.length) { |index| stack[index] }
              stack_copy = purge_duplicates stack_copy, multiple_token
              if stack_copy == rule
                return production
              end 
            end
          else
            if stack == rule
              return production
            end 
          end
        end
      end
      return false
    end
    def purge_duplicates(stack,multiple_token)
      @token_count = 0
      stack.each do |token|
        if token == multiple_token
          @token_count = @token_count + 1
        end
      end
      if @token_count == 0
        if stack.length > 0
          @working_stack.push stack.shift
        end
        stack = @working_stack
        @working_stack = []
        return stack
      end
      if stack.first == @working_stack.last && stack.first == multiple_token
        stack.shift
      else
        @working_stack.push stack.shift
      end
      purge_duplicates(stack,multiple_token)
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
