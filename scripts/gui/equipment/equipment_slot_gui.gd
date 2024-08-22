class_name  EquipmentSlotGui extends Button

@export var slot_type: EquipmentSlot.EquipmentSlotType

@onready var background: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer
@onready var equipment = preload("res://inventory/player_equipment.tres")

var item_gui: ItemEquipGui

func insert(ig: ItemEquipGui):
	item_gui = ig
	background.frame = 1
	container.add_child(item_gui)
	if !item_gui.inventory_slot || equipment.get_slot(slot_type) == item_gui.inventory_slot:
		return
	equipment.insert_slot(slot_type, item_gui.inventory_slot)
	

func take_item():
	var item = item_gui
	equipment.remove_slot(slot_type)
	
	return item

func clear() -> void:
	if item_gui:
		container.remove_child(item_gui)
		item_gui = null
		background.frame = 0

func is_empty() -> bool :
	return !item_gui
