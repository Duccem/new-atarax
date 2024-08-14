extends Area2D

@export var item_resource: InventoryItem

func collect(inventory: Inventory):
	inventory.insert_item(item_resource)
	queue_free()


func _on_body_entered(_body:Node2D):
	if _body.name == "player":
		collect(_body.inventory)
