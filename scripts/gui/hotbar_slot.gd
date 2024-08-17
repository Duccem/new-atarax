extends Button

@onready var background_sprite: Sprite2D = $background
@onready var item_stack_gui: ItemStackGui = $CenterContainer/ItemStack

func update_to_slot(slot: InventorySlot) -> void:
	if !slot.item:
		item_stack_gui.visible = false
		background_sprite.frame = 0
		return
	item_stack_gui.update(slot)
	item_stack_gui.visible = true
	background_sprite.frame = 1
