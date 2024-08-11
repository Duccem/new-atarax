extends Node
var player_health = 100

signal player_health_changed

func reset_game():
  await  get_tree().create_timer(3).timeout
  player_health = 100
  get_tree().reload_current_scene()

