extends Area2D

var player_reference
var gun
var player_alive = false
var score = 200
var lasers = preload("res://Scenes/Actors/UFOLaser.tscn")
var fire_delay = 20
var current_fire_delay = 0
var initial_spawn_posion : Vector2
var height_distance = 0
var vertical_speed = .30

var change_vertical_direction_timer = 40
var current_direction_timer = 0

var current_health = 0

var is_destroyed = false
func _enter_tree():
	_connect_signals()

func _ready():
	gun = get_node("Gun")
	position = Vector2(-15, GameManager.screen_height/2)
	height_distance = GameManager.screen_height / 4

func _connect_signals():
	Signals.player1_position.connect(_follow_on_target)
	Signals.player1_spawned.connect(_target_acquired)
	Signals.ship_destroyed.connect(_target_lost)
	

func _process(_delta):
	if(position.x > GameManager.screen_width + 5 || is_destroyed):
		queue_free()

	if(current_fire_delay >0):
		current_fire_delay -= .1
	if(current_direction_timer >0):
		current_direction_timer -= .1
	_move_vertical()
	_move_horizontal()
	current_fire_delay -=.1
	if(player_reference != null && player_alive):
		if(current_fire_delay <= 0):
			gun.look_at(player_reference)
			var laser = lasers.instantiate()
			laser.position = position
			laser.rotation = gun.rotation
			get_parent().add_child(laser)
			current_fire_delay = fire_delay

func _move_vertical():
	position.y += vertical_speed
	if(current_direction_timer >0):
		current_direction_timer -= .1
	if(current_direction_timer <= 0):
		current_direction_timer = change_vertical_direction_timer
		vertical_speed *= -1
		

func _move_horizontal():
	position.x += .25
	pass


func _target_lost():
	player_alive = false

func _target_acquired(player1_ship):
	player_alive = true

func _follow_on_target(position : Vector2):
	if(player_alive):
		player_reference = position

func ship_hit():
	is_destroyed = true
	Signals.emit_signal("add_score", score)
