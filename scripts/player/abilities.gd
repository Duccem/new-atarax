extends Node2D
class_name Abilities

@onready var abilities = get_children()

func cast(index: int):
  if index < abilities.size():
    abilities[index].use()
  else:
    print("Ability not found")
