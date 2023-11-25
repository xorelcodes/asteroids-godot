extends Node


var enemy_ufo = preload("res://Scenes/Actors/EnemyUFO.tscn")
var default_spawn_point : Vector2
var total_enemies = [] 
var timer : Timer
var can_spawn;

func _enter_tree():
	Signals.enemy_spawn_timer_hit.connect(_spawn_enemy)
	Signals.all_destroyed.connect(_despawn_enemies)
	Signals.ship_destroyed.connect(_despawn_enemies)
	Signals.enemy_destroyed.connect(_enemy_destroyed)
	Signals.spawn_player.connect(_start_spawning)

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

func _start_spawning():
	can_spawn = true
	_toggle_timer()

func _toggle_timer():
	timer.set_paused(!timer.is_paused)

func _spawn_enemy():
	if(can_spawn):
		var new_ufo : EnemyUFO = enemy_ufo.instantiate()
		new_ufo.position = default_spawn_point
		new_ufo.player_alive = true
		get_parent().add_child(new_ufo)
		total_enemies.push_back(new_ufo)

func _enemy_destroyed(destroyed_enemy : EnemyUFO):
	total_enemies.remove_at(total_enemies.find(destroyed_enemy))
	Signals.emit_signal("add_score", destroyed_enemy.score)
	
func _despawn_enemies():
	print("Despawning")
	can_spawn = false
	_toggle_timer()
	for n in total_enemies:
		n.despawn()
		total_enemies.remove_at(total_enemies.find(n))

