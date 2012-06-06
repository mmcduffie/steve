module Steve
  class Token
    attr_accessor :name
    attr_accessor :value
    attr_accessor :root
    def initialize(name,value,root)
      @name  = name
      @value = value
      @root  = root
    end
    def ==(comparison_token)
      if comparison_token.respond_to?('name')
        self.name == comparison_token.name
      else
        super(comparison_token)
      end
    end
  end
end
