require 'helper'

class SteveObjectTest < Test::Unit::TestCase
  def test_create_slot_and_lookup
    object = Steve::Object.new
    object.add_slot
    test_slot = Steve::Slot.new(nil,nil)
    assert_equal test_slot, object.find_slot_by_id(1), "Slot not found."
  end
  def test_lookup_that_should_fail
    object = Steve::Object.new
    object.add_slot
    object.add_slot
    assert_equal false, object.find_slot_by_id(3), "Slot doesn't exist, should have returned false."
  end
end
