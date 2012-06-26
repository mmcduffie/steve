module Steve
  class EBNFParser < Parser
    def initialize
      @input_tokens = []
      @parser_stack = []
      @working_stack = []
      @token_count = 0
      string_token = Steve::Token.new({ :name => "STRING" })
      end_grouping_name_token = Steve::Token.new({ :name => "END_GROUPING_NAME" , :value => ":" })
      end_rules_token = Steve::Token.new({ :name => "END_RULES", :value => ";" })
      or_token = Steve::Token.new({ :name => "OR", :value => "|" })
      grouping_name_token = Steve::Token.new({ :name => "GROUPING_NAME" })
      grouping_name_token.rules = [[string_token,end_grouping_name_token]]
      grouping_rule_token = Steve::Token.new({ :name => "GROUPING_RULE" , :multiples => true })
      grouping_rule_token.rules = [[string_token,end_rules_token],[string_token,or_token]]
      grouping_token = Steve::Token.new({ :name => "GROUPING", :multiples => true })
      grouping_token.rules = [[grouping_name_token,grouping_rule_token]]
      grammar_token = Steve::Token.new({ :name => "GRAMMAR", :root => true })
      grammar_token.rules = [[grouping_token]]
      @grammar_rules = [
        string_token,
        end_grouping_name_token,
        end_rules_token,
        or_token,
        grouping_name_token,
        grouping_rule_token,
        grouping_token,
        grammar_token
      ]
    end
  end
end
