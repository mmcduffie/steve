module Steve
  #
  # Parser is a shift-reduce parser that recursively runs over
  # the tokens in the input until it reduces the input to one
  # root token that contains all others.
  #
  class Parser
    attr_accessor :parser_stack
    attr_accessor :grammar_rules
    attr_accessor :input_tokens
    attr_accessor :recursive_mode
    attr_accessor :recursive_token
    attr_accessor :recursive_token_parent
    def initialize(grammar_rules)
      @grammar_rules = grammar_rules
      @parser_stack = []
      @recursive_mode = false
      @recursive_token = ""
      @recursive_token_parent = nil
    end
    def reduce
      unless @input_tokens.empty?
        return @input_tokens if @input_tokens[0]["root"] == true #base case, as our goal is to reduce to one root
      end
      unless @input_tokens.empty?
        #on each pass, we take a token from the input stack, and push it onto the parser stack
        @parser_stack.push @input_tokens.slice!(0)
      end
      if @recursive_mode #in recursive mode, we only look to see if the current token matches the last one.
        last_token = @parser_stack.last
        if last_token != @recursive_token or @input_tokens.empty?
          name = @recursive_token_parent.name
          root = @recursive_token_parent.root?
          @parser_stack #the last thing on the stack should not be included.
          reduced_token = { "name" => name, "value" => @parser_stack, "root" => root }
          @parser_stack = []
          @parser_stack.push last_token
          @input_tokens.push reduced_token
          @recursive_mode = false       #reset
          @recursive_token = ""         #reset
          @recursive_token_parent = nil #reset
        end
      else
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
          rule.recursive_components.each do |component|
            if names == component
              @recursive_mode = true #finding a token that we can have more than one of triggers recursive mode.
              @recursive_token = @parser_stack.last
              @recursive_token_parent = @grammar_rules[symbol]
            end
          end
        end
      end
      reduce
    end
  end
end
