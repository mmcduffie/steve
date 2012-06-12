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
  #
  # Objects are the main building block of any Steve program. They consist of
  # slots that can be created and have their values changed, but never have their
  # names changed or be deleted entirely, because that might change the external
  # interface of the object. To crate a get a similar object with fewer slots one 
  # must first create a new object and then copy values from the old one.
  #
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
      return @ids[used_slots]
    end
    def add_slot_with_name(name)
      new_slot_id = add_slot
      index = new_slot_id - 1
      @keys[index] = name
      return new_slot_id
    end
    def add_slot_with_value(value)
      new_slot_id = add_slot
      index = new_slot_id - 1
      @values[index] = value
      return new_slot_id
    end
    def add_slot_with_name_and_value(name,value)
      new_slot_id = add_slot
      index = new_slot_id - 1
      @keys[index] = name
      @values[index] = value
      return new_slot_id
    end
    def set_value_at_id(id,value)
      index = id - 1
      if @ids[index]
        @values[index] = value
      else
        raise RuntimeError, "Cannot set value on a slot (#{id}) that doesn't exist."
      end
      return id
    end
    def set_name_at_id(id,name)
      index = id - 1
      if @ids[index]
        @keys[index] = name
      else
        raise RuntimeError, "Cannot set name on a slot (#{id}) that doesn't exist."
      end
      return id
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
