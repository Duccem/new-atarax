extends Resource

class_name Inventory

@export var slots: Array[InventorySlot] = []
signal updated

func insert_item(item: InventoryItem) -> void:
  var slots_with_the_item = slots.filter(func(slot): return slot.item == item && slot.quantity < slot.item.max_quantity)
  if !slots_with_the_item.is_empty():
    slots_with_the_item[0].quantity += 1
  else:
    var empty_slots = slots.filter(func(slot): return slot.item == null)
    if !empty_slots.is_empty():
      empty_slots[0].item = item
      empty_slots[0].quantity = 1
  updated.emit()

func remove_at_index(index: int):
  slots[index] = InventorySlot.new()
  updated.emit()

func remove_slot(slot: InventorySlot):
  var index = slots.find(slot)
  if index < 0: return
  remove_at_index(index)

func insert_slot(index: int, slot: InventorySlot):
  slots[index] = slot
  updated.emit()

func use_item_at_index(index: int):
  if index < 0 or index >= slots.size() or !slots[index].item: return
  if slots[index].quantity > 1:
    slots[index].quantity -= 1
  else:
    remove_at_index(index)
  updated.emit()