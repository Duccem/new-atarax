class_name InventoryGui extends Control

var is_open = false

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var ItemStackGuiClass = preload("res://scenes/gui/inventory/item_stack_gui.tscn")
@onready var hotbar_slots: Array = $NinePatchRect/HBoxContainer.get_children()
@onready var slots: Array = hotbar_slots + $NinePatchRect/GridContainer.get_children()

var item_in_hand: ItemStackGui
var old_item_index = -1
var locked = false

signal toggled

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventory_slot: InventorySlot = inventory.slots[i]

		if !inventory_slot.item:
			slots[i].clear()
			continue

		var item_stack = slots[i].item_stack
		if !item_stack:
			item_stack = ItemStackGuiClass.instantiate()
			slots[i].insert(item_stack);
		
		item_stack.update(inventory_slot)

func _ready():
	visible = is_open
	inventory.updated.connect(update)
	connect_slots()
	update()

func _input(_event):
	if item_in_hand && !locked && Input.is_action_just_pressed("throw_item"):
		put_item_back()
	update_item_in_hand()

func toggle_inventory():
	is_open = !is_open
	visible = is_open
	toggled.emit(is_open)


func on_slot_selected(slot):
	if locked: return

	if slot.is_empty() && item_in_hand:
		insert_item_in_slot(slot)
		return
	if !slot.is_empty() && !item_in_hand:
		take_item_from_slot(slot)
		return
	if !slot.is_empty() && item_in_hand:
		if slot.item_stack.inventory_slot.item.name == item_in_hand.inventory_slot.item.name:
			stack_items(slot)
		else:
			swap_items(slot)
		return

func on_slot_right_pressed(slot):
	if locked: return
	if slot.is_empty(): return
	take_the_half(slot)

func take_item_from_slot(slot):
	item_in_hand = slot.take_item()
	add_child(item_in_hand)
	update_item_in_hand()
	old_item_index = slot.index

func insert_item_in_slot(slot):
	var item = item_in_hand
	remove_child(item_in_hand)
	slot.insert(item)
	item_in_hand = null
	old_item_index = -1

func swap_items(slot):
	var tempItem = slot.take_item()
	insert_item_in_slot(slot)
	item_in_hand = tempItem
	add_child(item_in_hand)
	update_item_in_hand()

func stack_items(slot):
	var slot_item: ItemStackGui = slot.item_stack
	var max_quantity = slot_item.inventory_slot.item.max_quantity
	var total_quantity = slot_item.inventory_slot.quantity + item_in_hand.inventory_slot.quantity

	if slot_item.inventory_slot.quantity == max_quantity:
		swap_items(slot)
		return
	
	if total_quantity <= max_quantity:
		slot_item.inventory_slot.quantity = total_quantity
		remove_child(item_in_hand)
		item_in_hand = null
		old_item_index = -1
	else: 
		slot_item.inventory_slot.quantity = max_quantity
		item_in_hand.inventory_slot.quantity = total_quantity - max_quantity
	
	slot_item.update(slot_item.inventory_slot)
	if item_in_hand: item_in_hand.update(item_in_hand.inventory_slot)
	
func update_item_in_hand():
	if !item_in_hand: return
	item_in_hand.global_position = get_global_mouse_position() - item_in_hand.size / 2

func put_item_back():
	locked = true
	if old_item_index < 0:
		var empty_slots = slots.filter(func(s): return s.is_empty())
		if empty_slots.is_empty(): return
		old_item_index = empty_slots[0].index
	
	var target_slot = slots[old_item_index]
	var tween = create_tween()
	var target_position = target_slot.global_position + target_slot.size / 2
	tween.tween_property(item_in_hand, "global_position", target_position, 0.2)
	await  tween.finished
	insert_item_in_slot(target_slot)
	locked = false

func take_the_half(slot):
	if slot.is_empty(): return
	if slot.item_stack.inventory_slot.quantity == 1:
		take_item_from_slot(slot)
		return
	
	var slot_item: ItemStackGui = slot.take_item()
	var half = floor(slot_item.inventory_slot.quantity / 2)
	
	var new_slot_item = slot_item
	new_slot_item.inventory_slot.quantity = new_slot_item.inventory_slot.quantity - half
	new_slot_item.update(new_slot_item.inventory_slot)
	slot.insert(slot_item)

	item_in_hand = ItemStackGuiClass.instantiate()
	item_in_hand.inventory_slot = InventorySlot.new()

	for i in item_in_hand.get_children():
		item_in_hand.remove_child(i)
		i.queue_free()
	item_in_hand.item_sprite = slot_item.item_sprite.duplicate()
	item_in_hand.quantity_label = slot_item.quantity_label.duplicate()

	item_in_hand.add_child(item_in_hand.item_sprite)
	item_in_hand.add_child(item_in_hand.quantity_label)
	
	item_in_hand.inventory_slot.item = slot_item.inventory_slot.item
	item_in_hand.inventory_slot.quantity = half
	item_in_hand.update(item_in_hand.inventory_slot)

	add_child(item_in_hand)
	
	update_item_in_hand()
	
func add_item_in_hand(slot):
	item_in_hand = ItemStackGuiClass.instantiate()
	item_in_hand.inventory_slot = InventorySlot.new()

	for i in item_in_hand.get_children():
		item_in_hand.remove_child(i)
		i.queue_free()

	item_in_hand.item_sprite = slot.item_sprite.duplicate()
	var slots_with_stack = slots.filter(func(s): return s.item_stack != null)
	item_in_hand.quantity_label = slots_with_stack[0].item_stack.quantity_label.duplicate()
	item_in_hand.add_child(item_in_hand.item_sprite)
	item_in_hand.add_child(item_in_hand.quantity_label)
	item_in_hand.inventory_slot.item = slot.inventory_slot.item
	item_in_hand.inventory_slot.quantity = 1
	item_in_hand.update(item_in_hand.inventory_slot)
	add_child(item_in_hand)
	update_item_in_hand()

func connect_slots(): 
	for i in range(slots.size()):
		slots[i].index = i
		slots[i].pressed.connect(Callable(on_slot_selected).bind(slots[i]))
		slots[i].right_pressed.connect(Callable(on_slot_right_pressed).bind(slots[i]))
