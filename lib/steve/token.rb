module Steve
  class Token
    attr_accessor :name
    attr_accessor :value
    attr_accessor :root
    def initialize(name,root,value)
      @name  = name
      @value = value
      @root  = root
    end
    def ==(comparison_token)
      self.name == comparison_token.name
    end
  end
end
