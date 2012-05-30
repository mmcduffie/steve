module Steve
  #
  # Symbols of the Symbol class represent non-terminal symbols
  # and the components that they can contain. Steve doesn't 
  # parse BNF grammars yet, so you have to achive a similar
  # result by creating Symbols and giving them components that
  # when matched will be grouped into non-terminals.
  #
  class Symbol
    attr_accessor :name
    attr_accessor :components
    attr_accessor :root
    def initialize(name,root)
      @name = name
      @root = root
      @components = []
      @recursive_components = []
    end
    def root?
      @root
    end
    def add_component(component_rules)
      @components.push component_rules
    end
    def add_recursive_component(component)
      @recursive_components.push component
    end
  end
end
