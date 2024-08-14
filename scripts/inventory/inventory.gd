extends Resource

class_name Inventory

@export var slots: Array[InventorySlot] = []
signal updated

func insert_item(item: InventoryItem) -> void:
  for slot in slots:
    if !slot.item:
      slot.item = item
      slot.quantity = 1
      updated.emit()
      return
    if slot.item == item:
      if !slot.item.stackable:
        continue
      elif slot.quantity == slot.item.max_quantity:
        continue
      else:
        slot.quantity += 1
        updated.emit()
        return