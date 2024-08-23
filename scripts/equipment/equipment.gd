class_name  Equipment extends Resource

@export var head: InventorySlot
@export var chest: InventorySlot
@export var legs: InventorySlot
@export var right_arm: InventorySlot
@export var left_arm: InventorySlot

var slots = {
  "head": head,
  "chest": chest,
  "legs": legs,
  "right_arm": right_arm,
  "left_arm": left_arm
}

signal updated
signal weapon_inserted

func insert_slot(slot_type: EquipmentSlot.EquipmentSlotType, slot: InventorySlot):
  match slot_type:
    EquipmentSlot.EquipmentSlotType.HEAD:
      head = slot
    EquipmentSlot.EquipmentSlotType.CHEST:
      chest = slot
    EquipmentSlot.EquipmentSlotType.LEGS:
      legs = slot
    EquipmentSlot.EquipmentSlotType.RIGHT_ARM:
      right_arm = slot
    EquipmentSlot.EquipmentSlotType.LEFT_ARM:
      left_arm = slot
  updated.emit()

func get_slot(slot_type: EquipmentSlot.EquipmentSlotType) -> InventorySlot:
  match slot_type:
    EquipmentSlot.EquipmentSlotType.HEAD:
      return head
    EquipmentSlot.EquipmentSlotType.CHEST:
      return chest
    EquipmentSlot.EquipmentSlotType.LEGS:
      return legs
    EquipmentSlot.EquipmentSlotType.RIGHT_ARM:
      return right_arm
    EquipmentSlot.EquipmentSlotType.LEFT_ARM:
      return left_arm
    _:
      return null

func remove_slot(slot_type: EquipmentSlot.EquipmentSlotType):
  match slot_type:
    EquipmentSlot.EquipmentSlotType.HEAD:
      head = InventorySlot.new()
    EquipmentSlot.EquipmentSlotType.CHEST:
      chest = InventorySlot.new()
    EquipmentSlot.EquipmentSlotType.LEGS:
      legs = InventorySlot.new()
    EquipmentSlot.EquipmentSlotType.RIGHT_ARM:
      right_arm = InventorySlot.new()
    EquipmentSlot.EquipmentSlotType.LEFT_ARM:
      left_arm = InventorySlot.new()
  updated.emit()

func instantiate_weapon(_weapon: PackedScene):
  weapon_inserted.emit(_weapon)