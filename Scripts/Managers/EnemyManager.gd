extends Node


var enemy_ufo = preload("res://Scenes/Actors/EnemyUFO.tscn")
var default_spawn_point : Vector2
var total_enemies = [] 
var timer : Timer

func _enter_tree():
	Signals.enemy_spawn_timer_hit.connect(_spawn_enemy)

func _ready():
	_ready_timer()
	default_spawn_point = Vector2(-15, GameManager.screen_height/2)

func _ready_timer():
	timer = Timer.new()
	timer.timeout.connect(_spawn_enemy)
	add_child(timer)
	timer.wait_time = 10
	timer.one_shot = false 
	timer.start()

func _toggle_timer():
	timer.set_paused(!timer.is_paused)

func _spawn_enemy():
	var new_ufo : EnemyUFO = enemy_ufo.instantiate()
	new_ufo.position = default_spawn_point
	new_ufo.player_alive = true
	get_parent().add_child(new_ufo)
	total_enemies.push_back(new_ufo)

