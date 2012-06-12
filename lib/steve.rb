# The Steve module is the main namespace for all classes in Steve.
# To use Steve, you can simply require this file (/lib/steve.rb) and
# you will have access to all mothods, modules, and classes in Steve.
module Steve
  
  VERSION = '0.0.0'
  
  autoload :Lexer, "steve/lexer"
  autoload :Parser, "steve/parser"
  autoload :Symbol, "steve/symbol"
  autoload :Token, "steve/token"
  autoload :Interpreter, "steve/interpreter"
  autoload :MathExpression, "steve/math_expression"
  autoload :NewParser, "steve/new_parser"
  autoload :Object, "steve/object"
  autoload :Slot, "steve/object"

  # This is the main exec for Steve. This should get called weather we
  # are invoking Steve from the command line after insalling as a gem or 
  # using Steve as a required library.
  def self.execute(source_file)
    
  end
end
