module Steve
  class EBNFParser < Parser
    def initialize
      @grammar_rules = []
      @input_tokens = []
      @parser_stack = []
      @working_stack = []
      @token_count = 0
    end
  end
end
