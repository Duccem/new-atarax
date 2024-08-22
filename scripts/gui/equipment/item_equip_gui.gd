extends Panel
class_name ItemEquipGui

var inventory_slot: InventorySlot

@onready var item_sprite: Sprite2D = $item

func update(slot: InventorySlot):
	inventory_slot = slot
	if !slot || !slot.item: return
	item_sprite.texture = slot.item.texture
	item_sprite.visible = true