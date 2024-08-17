extends Panel


@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var slots: Array = $container.get_children()
@onready var selector: Sprite2D = $selector

var currently_slot_selected = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	inventory.updated.connect(update)

func update() -> void:
	for i in range(slots.size()):
		var inventory_slot: InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slot)

func move_selector(dir = 1):
	currently_slot_selected = (currently_slot_selected + dir) % slots.size()
	selector.global_position = slots[currently_slot_selected].global_position
		
func _unhandled_input(event):
	if event.is_action_pressed("use_item"):
		inventory.use_item_at_index(currently_slot_selected)
	if event.is_action_pressed("move_hotbar_selector_down"):
		move_selector(1)
	if event.is_action_pressed("move_hotbar_selector_up"):
		move_selector(-1)