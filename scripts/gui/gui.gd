extends CanvasLayer

@onready var inventory = $Inventory

func _input(event):
	if event.is_action_pressed("inventory_toggle"):
		inventory.toggle_inventory()
