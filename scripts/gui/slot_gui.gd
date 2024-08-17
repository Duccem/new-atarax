class_name SlotGui extends Button

@onready var background: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer
@onready var inventory = preload("res://inventory/player_inventory.tres")

var item_stack: ItemStackGui
var index: int
signal right_pressed

func insert(isg: ItemStackGui):
	item_stack = isg
	background.frame = 1
	container.add_child(item_stack)
	if !item_stack.inventory_slot || inventory.slots[index] == item_stack.inventory_slot:
		return
	inventory.insert_slot(index, item_stack.inventory_slot)

func take_item():
	var item = item_stack
	inventory.remove_slot(item_stack.inventory_slot)
	
	return item

func clear() -> void:
	if item_stack:
		container.remove_child(item_stack)
		item_stack = null
		background.frame = 0

func is_empty() -> bool :
	return !item_stack

func _gui_input(_event: InputEvent):
	if Input.is_action_just_pressed("half_stack"):
		right_pressed.emit()
