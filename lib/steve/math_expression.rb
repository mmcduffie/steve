module Steve
  class MathExpression
    attr_accessor :input_tokens
    attr_accessor :output_string
    def initialize(input_tokens)
      @input_tokens = input_tokens
      @output_string = ""
    end
    def build_string
      @input_tokens.each do |token|
        @output_string << token['value']
      end
      return @output_string
    end
    def eval_string
      return eval @output_string
    end
  end
end
