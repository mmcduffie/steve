module Steve
  class Token
    attr_accessor :name
    attr_accessor :value
    attr_accessor :root
    attr_accessor :components
    attr_accessor :recursive_components
    def initialize(name,value,root,components,recursive_components)
      @name                 = name
      @value                = value
      @root                 = root
      @components           = components
      @recursive_components = recursive_components
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
