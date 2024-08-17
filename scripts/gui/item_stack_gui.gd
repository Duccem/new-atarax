extends Panel
class_name ItemStackGui

var inventory_slot

@onready var item_sprite: Sprite2D = $item
@onready var quantity_label: Label = $quantity

func update(slot: InventorySlot):
	inventory_slot = slot
	if !slot || !slot.item: return
	item_sprite.texture = slot.item.texture
	item_sprite.visible = true
	if slot.quantity > 1:
		quantity_label.text = str(slot.quantity)
		quantity_label.visible = true
	else:
		quantity_label.visible = false
