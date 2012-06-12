module Steve
  class Slot
    attr_accessor :name
    attr_accessor :value
    def initialize(name,value)
      @name = name
      @value = value
    end
    def ==(other_slot)
      if @name == other_slot.name && @value == other_slot.value
        return true
      else
        return false
      end
    end
  end

  class Object
    attr_accessor :ids
    attr_accessor :keys
    attr_accessor :values
    def initialize
      @ids = []
      @keys = []
      @values = []
    end
    def add_slot
      used_slots = @ids.length
      @ids[used_slots] = used_slots + 1
      @keys[used_slots] = nil
      @values[used_slots] = nil
    end
    def find_slot_by_id(id)
      index = id - 1
      if @ids[index]
        return slot = Steve::Slot.new(@keys[index],@values[index])
      else
        return false
      end    
    end
  end
end
