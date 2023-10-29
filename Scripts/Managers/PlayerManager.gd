class_name PlayerManager extends Node


var player_template = preload("res://Scenes/Actors/player.tscn")
var player1

func _enter_tree():
	Signals.spawn_player.connect(_spawn_player)
	Signals.respawn.connect(_spawn_player)
	#player1_spawned.connect(GameManager.ready_player1)
	
	
#initial spawn in of the player. Can change to include variables for multiplayer?
func _spawn_player():
	var screen_width = GameManager.screen_width
	var screen_height = GameManager.screen_height
	player1 = player_template.instantiate()
	player1.position = Vector2(screen_width/2, screen_height/2)
	add_child(player1)
	Signals.emit_signal("player1_spawned", player1)