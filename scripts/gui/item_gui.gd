extends Panel
class_name ItemStackGui

var inventorySlot

@onready var itemSprite: Sprite2D = $item
@onready var quantityLabel: Label = $quantity

func update(slot: InventorySlot):
	inventorySlot = slot
	if !slot || !slot.item: return

	itemSprite.visible = true
	itemSprite.texture = slot.item.texture

	if slot.quantity > 1:
		quantityLabel.visible = true
		quantityLabel.text = str(slot.quantity)
	else:
		quantityLabel.visible = false