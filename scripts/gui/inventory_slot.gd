extends Panel

@onready var background: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var quantityLabel: Label = $CenterContainer/Panel/quantity

func update(slot: InventorySlot):
	if !slot.item:
		background.frame = 0
		itemSprite.visible = false
		quantityLabel.visible = false
	else: 
		background.frame = 1
		itemSprite.texture = slot.item.texture
		itemSprite.visible = true
		quantityLabel.visible = true if slot.quantity > 1 else false
		quantityLabel.text = str(slot.quantity)

