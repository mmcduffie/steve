module Steve
  class Interpreter
    attr_accessor :abstract_syntax_tree
    attr_accessor :symbol_table
    def initialize(abstract_syntax_tree)
      @abstract_syntax_tree = abstract_syntax_tree
      @symbol_table = []
    end
    def execute

    end
  end
end
