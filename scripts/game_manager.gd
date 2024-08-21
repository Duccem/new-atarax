extends Node
var player_health = 100
var game_paused = false

signal player_health_changed

func reset_game():
  await  get_tree().create_timer(3).timeout
  player_health = 100
  get_tree().reload_current_scene()

func pause_game():
  game_paused = true
  get_tree().paused = true

func resume_game():
  game_paused = false
  get_tree().paused = false