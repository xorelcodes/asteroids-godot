class_name PlayerManager extends Node

signal player1_spawned(player : PlayerShip)

var player_template = preload("res://Scenes/Actors/player.tscn")
var player1

func _enter_tree():
	SceneManager.spawn_player.connect(_spawn_player)
	GameManager.respawn.connect(_spawn_player)
	player1_spawned.connect(GameManager.ready_player1)
	
	
#initial spawn in of the player. Can change to include variables for multiplayer?
func _spawn_player():
	var screen_width = GameManager.screen_width
	var screen_height = GameManager.screen_height
	player1 = player_template.instantiate()
	player1.position = Vector2(screen_width/2, screen_height/2)
	player1.ship_destroyed.connect(GameManager.lose_life)
	add_child(player1)
	emit_signal("player1_spawned", player1)