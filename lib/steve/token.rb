module Steve
  class Token
    attr_accessor :name
    attr_accessor :value
    attr_accessor :root
    attr_accessor :components
    attr_accessor :multiples
    def initialize(options = {})
      @name       = options[:name]       || "NULL"
      @value      = options[:value]      || "NULL"
      @root       = options[:root]       || false
      @components = options[:components] || []
      @multiples  = options[:multiples]  || false
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
