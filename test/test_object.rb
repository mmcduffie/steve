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
  def test_return_from_add_slot
    object = Steve::Object.new
    object.add_slot
    assert_equal 2, object.add_slot, "Adding a slot should return it's id to the caller."
  end
  def test_add_slot_with_name
    object = Steve::Object.new
    object.add_slot_with_name("steve")
    assert_equal "steve", object.keys[0], "Slot name is not what we set."
  end
  def test_add_slot_with_name_returns_id
    object = Steve::Object.new
    assert_equal 1, object.add_slot_with_name("steve"), "Any of the add slot methods should return created id."
  end
  def test_get_correct_name_from_id_lookup
    object = Steve::Object.new
    new_id = object.add_slot_with_name("steve")
    found_slot = object.find_slot_by_id(new_id)
    assert_equal "steve", found_slot.name, "Slot should have the same name we set."
  end
  def test_add_slot_with_value
    object = Steve::Object.new
    object.add_slot
    object.add_slot
    new_id = object.add_slot_with_value(100)
    found_slot = object.find_slot_by_id(new_id)
    assert_equal 100, found_slot.value, "Slot should have the value we set."
  end
  def test_add_slot_with_name_and_value
    object = Steve::Object.new
    object.add_slot
    object.add_slot
    new_id = object.add_slot_with_name_and_value("the_number_five",5)
    found_slot = object.find_slot_by_id(new_id)
    assert_equal "the_number_five", found_slot.name, "Slot should have the same name we set."
    assert_equal 5, found_slot.value, "Slot should have the value we set."
  end
  def test_set_value_on_existing_slot
    object = Steve::Object.new
    object.add_slot_with_name_and_value("foo_name","foo_value")
    slot_with_new_value = object.set_value_at_id(1,"new_value")
    found_slot = object.find_slot_by_id(slot_with_new_value)
    assert_equal "new_value", found_slot.value, "Slot should have the value we set."
  end
  def test_set_value_on_non_existing_slot
    object = Steve::Object.new
    object.add_slot_with_name_and_value("foo_name","foo_value")
    assert_raise RuntimeError do
      slot_with_new_value = object.set_value_at_id(2,"new_value")
    end
  end
end
