class_name EquipmentGui extends Control

signal toggled
var is_open = false

@onready var head_slot = $NinePatchRect/slots/Head
@onready var chest_slot = $NinePatchRect/slots/Chest
@onready var legs_slot = $NinePatchRect/slots/Legs
@onready var right_arm = $NinePatchRect/slots/RightArm
@onready var left_arm = $NinePatchRect/slots/LeftArm

@export var inventory_ui: InventoryGui

func _ready():
	visible = is_open
	head_slot.pressed.connect(head_clicked)
	chest_slot.pressed.connect(chest_clicked)
	legs_slot.pressed.connect(legs_clicked)
	right_arm.pressed.connect(right_arm_clicked)
	left_arm.pressed.connect(left_arm_clicked)

func toggle():
	is_open = !is_open
	visible = is_open
	toggled.emit(is_open)

func head_clicked():
	if inventory_ui.item_in_hand:
		var item = inventory_ui.item_in_hand
		inventory_ui.remove_child(inventory_ui.item_in_hand)
		head_slot.insert(item)
		inventory_ui.item_in_hand = null
	else:
		inventory_ui.item_in_hand = head_slot.take_item()
		inventory_ui.add_child(inventory_ui.item_in_hand)
		inventory_ui.update_item_in_hand()
		head_slot.clear()

func chest_clicked():
	print("Chest clicked")

func legs_clicked():
	print("Legs clicked")

func right_arm_clicked():
	print("Right arm clicked")

func left_arm_clicked():
	print("Left arm clicked")
