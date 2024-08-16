extends Panel
class_name ItemStackGui

var inventorySlot

@onready var itemSprite: Sprite2D = $item
@onready var quantityLabel: Label = $quantity

func update(slot: InventorySlot):
	inventorySlot = slot
	if !slot || !slot.item: return
	itemSprite.texture = slot.item.texture
	itemSprite.visible = true
	if slot.quantity > 1:
		quantityLabel.text = str(slot.quantity)
		quantityLabel.visible = true
	else:
		quantityLabel.visible = false
