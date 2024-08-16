extends Button

@onready var background: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer
@onready var inventory = preload("res://inventory/player_inventory.tres")

var itemStackGui: ItemStackGui
var index: int
signal right_pressed

func insert(isg: ItemStackGui):
	itemStackGui = isg
	background.frame = 1
	container.add_child(itemStackGui)
	if !itemStackGui.inventorySlot || inventory.slots[index] == itemStackGui.inventorySlot:
		return
	inventory.insert_slot(index, itemStackGui.inventorySlot)

func take_item():
	var item = itemStackGui
	inventory.remove_slot(itemStackGui.inventorySlot)
	container.remove_child(itemStackGui)
	itemStackGui = null
	background.frame = 0
	return item

func is_empty() -> bool :
	return !itemStackGui

func _gui_input(_event: InputEvent):
	if Input.is_action_just_pressed("half_stack"):
		right_pressed.emit()
