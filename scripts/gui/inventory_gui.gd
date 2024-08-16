extends Control

var is_open = false

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var ItemStackGuiClass = preload("res://scenes/gui/item_stack_gui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var itemInHand: ItemStackGui
var old_item_index = -1
var locked = false

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]

		if !inventorySlot.item: continue

		var itemStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui);
		
		itemStackGui.update(inventorySlot)

func _ready():
	visible = is_open
	inventory.updated.connect(update)
	connect_slots()
	update()

func _input(_event):
	if itemInHand && !locked && Input.is_action_just_pressed("throw_item"):
		put_item_back()
	update_item_in_hand()

func toggle_inventory():
	is_open = !is_open
	visible = is_open
	if is_open:
		GameManager.pause_game()
	else:
		GameManager.resume_game()


func on_slot_selected(slot):
	if locked: return

	if slot.is_empty() && itemInHand:
		insert_item_in_slot(slot)
		return
	if !slot.is_empty() && !itemInHand:
		take_item_from_slot(slot)
		return
	if !slot.is_empty() && itemInHand:
		if slot.itemStackGui.inventorySlot.item.name == itemInHand.inventorySlot.item.name:
			stack_items(slot)
		else:
			swap_items(slot)
		return

func on_slot_right_pressed(slot):
	if locked: return
	if slot.is_empty(): return
	take_the_half(slot)

func take_item_from_slot(slot):
	itemInHand = slot.take_item()
	add_child(itemInHand)
	update_item_in_hand()
	old_item_index = slot.index

func insert_item_in_slot(slot):
	var item = itemInHand
	remove_child(itemInHand)
	slot.insert(item)
	itemInHand = null
	old_item_index = -1

func swap_items(slot):
	var tempItem = slot.take_item()
	insert_item_in_slot(slot)
	itemInHand = tempItem
	add_child(itemInHand)
	update_item_in_hand()

func stack_items(slot):
	var slot_item: ItemStackGui = slot.itemStackGui
	var max_quantity = slot_item.inventorySlot.item.max_quantity
	var total_quantity = slot_item.inventorySlot.quantity + itemInHand.inventorySlot.quantity

	if slot_item.inventorySlot.quantity == max_quantity:
		swap_items(slot)
		return
	
	if total_quantity <= max_quantity:
		slot_item.inventorySlot.quantity = total_quantity
		remove_child(itemInHand)
		itemInHand = null
		old_item_index = -1
	else: 
		slot_item.inventorySlot.quantity = max_quantity
		itemInHand.inventorySlot.quantity = total_quantity - max_quantity
	
	slot_item.update(slot_item.inventorySlot)
	if itemInHand: itemInHand.update(itemInHand.inventorySlot)
	
func update_item_in_hand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2

func put_item_back():
	locked = true
	if old_item_index < 0:
		var empty_slots = slots.filter(func(s): return s.is_empty())
		if empty_slots.is_empty(): return
		old_item_index = empty_slots[0].index
	
	var target_slot = slots[old_item_index]
	var tween = create_tween()
	var target_position = target_slot.global_position + target_slot.size / 2
	tween.tween_property(itemInHand, "global_position", target_position, 0.2)
	await  tween.finished
	insert_item_in_slot(target_slot)
	locked = false

func take_the_half(slot):
	if slot.is_empty(): return
	if slot.itemStackGui.inventorySlot.quantity == 1:
		take_item_from_slot(slot)
		return
	
	var slot_item: ItemStackGui = slot.take_item()
	var half = floor(slot_item.inventorySlot.quantity / 2)
	
	var new_slot_item = slot_item
	new_slot_item.inventorySlot.quantity = new_slot_item.inventorySlot.quantity - half
	new_slot_item.update(new_slot_item.inventorySlot)
	slot.insert(slot_item)

	itemInHand = ItemStackGuiClass.instantiate()
	itemInHand.inventorySlot = InventorySlot.new()

	for i in itemInHand.get_children():
		itemInHand.remove_child(i)
		i.queue_free()
	itemInHand.itemSprite = slot_item.itemSprite.duplicate()
	itemInHand.quantityLabel = slot_item.quantityLabel.duplicate()

	itemInHand.add_child(itemInHand.itemSprite)
	itemInHand.add_child(itemInHand.quantityLabel)
	
	itemInHand.inventorySlot.item = slot_item.inventorySlot.item
	itemInHand.inventorySlot.quantity = half
	itemInHand.update(itemInHand.inventorySlot)

	add_child(itemInHand)
	
	update_item_in_hand()
	

func connect_slots(): 
	for i in range(slots.size()):
		slots[i].index = i
		slots[i].pressed.connect(Callable(on_slot_selected).bind(slots[i]))
		slots[i].right_pressed.connect(Callable(on_slot_right_pressed).bind(slots[i]))
