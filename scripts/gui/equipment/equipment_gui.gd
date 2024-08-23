class_name EquipmentGui extends Control

signal toggled
var is_open = false

@onready var equipment = preload("res://inventory/player_equipment.tres")
@onready var ItemEquipmentGuiClass = preload("res://scenes/gui/equipment/item_equip_gui.tscn")
@onready var slots = {
	"head": $NinePatchRect/slots/Head,
	"chest": $NinePatchRect/slots/Chest,
	"legs": $NinePatchRect/slots/Legs,
	"right_arm": $NinePatchRect/slots/RightArm,
	"left_arm": $NinePatchRect/slots/LeftArm
}

@export var inventory_ui: InventoryGui

func _ready():
	visible = is_open
	equipment.updated.connect(update)
	connect_slots()
	update()
	
func connect_slots():
	for slot in slots.keys():
		slots[slot].pressed.connect(Callable(on_slot_selected).bind(slots[slot]))

func update():
	for slot in slots.keys():
		var inventory_slot = equipment.get_slot(slots[slot].slot_type)
		if !inventory_slot || !inventory_slot.item:
			slots[slot].clear()
			continue
		var item_gui = slots[slot].item_gui
		if !item_gui:
			item_gui = ItemEquipmentGuiClass.instantiate()
			slots[slot].insert(item_gui)
		item_gui.update(inventory_slot)

func toggle():
	is_open = !is_open
	visible = is_open
	toggled.emit(is_open)

func on_slot_selected(_slot):
	if _slot.is_empty() && inventory_ui.item_in_hand:
		insert_item_in_slot(_slot)
		return
	if !_slot.is_empty() && !inventory_ui.item_in_hand:
		take_item_from_slot(_slot)
		return

func insert_item_in_slot(slot):
	var item_gui = ItemEquipmentGuiClass.instantiate()
	item_gui.inventory_slot = InventorySlot.new()
	item_gui.item_sprite = inventory_ui.item_in_hand.item_sprite.duplicate()
	item_gui.add_child(item_gui.item_sprite)
	item_gui.inventory_slot.item = inventory_ui.item_in_hand.inventory_slot.item
	item_gui.update(item_gui.inventory_slot)
	slot.insert(item_gui)
	inventory_ui.remove_child(inventory_ui.item_in_hand)
	inventory_ui.item_in_hand = null
	inventory_ui.update_item_in_hand()
	if item_gui.inventory_slot.item is WeaponItem:
		equipment.instantiate_weapon(item_gui.inventory_slot.item.weapon)

func take_item_from_slot(slot):
	var item_gui = slot.take_item()
	inventory_ui.add_item_in_hand(item_gui)
	slot.clear()
