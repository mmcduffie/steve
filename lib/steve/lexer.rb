module Steve
  class Lexer
    attr_reader :definitions
    def initialize(definitions)
      @definitions = definitions
      @lexer_stack = []
      @result_stack = []
    end
    def scan(source_string)
      if source_string == ""
        if @lexer_stack.length > 0
          error_string = ""
          @lexer_stack.each do |char|
            error_string << char
            break if error_string.length > 3
          end
          raise SyntaxError, "Error lexing: Input not recognized by Steve. Error occurs here:\n#{error_string}\n^"
        end
        return @result_stack
      end
      @lexer_stack.push(source_string.slice!(0)) #push one char onto stack
      test_string = ""
      @lexer_stack.each do |char| #build a string from what we have so far
        test_string << char
      end
      test_string.lstrip! # leading spaces are useless at this point.
      @definitions.each do |definition|
        match_status = definition["regex"] =~ test_string #we get result of match as number so we can make sure it's exact
        if match_status == 0 #see if our test string matches a definition
          @result_stack.push(Steve::Token.new({ :name => definition["name"], :value => test_string}))
          #if it does, it should be returned as a token
          @lexer_stack = [] #reset stack
        end
      end
      scan(source_string) #recursively call until we've scaned everything.
    end
  end
end
