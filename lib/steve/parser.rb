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
        rule.recursive_components.each do |component|
          
        end
      end

      #puts "\n"
      #puts "I:#{@input_tokens.length} P:#{@parser_stack.length} N:#{names.length}"
      #puts "\n"

      reduce
    end
  end
end
