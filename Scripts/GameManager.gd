extends Node

@export var lives_left = 3
@export var high_score = 1000
@export var number_of_starting_asteroids = 3

var player_template = preload("res://Scenes/Actors/player.tscn")
var player1
var asteroids = []
var asteroid_template = preload("res://Scenes/Actors/asteroid.tscn")
var screen_width
var screen_height

var rng = RandomNumberGenerator.new()


var total_score: int

func _ready():
	#get screen height and width for later spawn calculations 
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y

	_spawn_init_asteroids()
	_spawn_player()
	pass

func _process(delta):
	if(Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()

#add to total score
func _add_score(points : int):
	total_score += points
	print("Total Score: " + str(total_score))

#lose a life, game over on 0 lives
func _lose_life():
	if(lives_left == 0):
		#end game state entered here
		pass
	lives_left -= 1
	print("Lives left: " + str(lives_left))

#initial spawn in of the player. Can change to include variables for multiplayer?
func _spawn_player():
	player1 = player_template.instantiate()
	player1.position = Vector2(screen_width/2, screen_height/2)
	player1.ship_destroyed.connect(_lose_life)
	add_child(player1)

#spawn in the initial asteroids based on the set amount of starting asteroids
func _spawn_init_asteroids():
	for n in number_of_starting_asteroids:
		var new_asteroid = asteroid_template.instantiate()
		var xRando 
		xRando = rng.randf_range(100, screen_width / 2 -50) if rng.randi_range(0,1) ==0 else rng.randf_range(screen_width + 50, screen_width  -100)
		var yRando
		yRando = rng.randf_range(100, screen_height / 2 -50) if rng.randi_range(0,1) ==0 else rng.randf_range(screen_height + 50, screen_height -100)
		new_asteroid.position = Vector2(xRando, yRando)
		new_asteroid.asteroid_destroyed.connect(_asteroid_destroyed)
		new_asteroid.scored.connect(_add_score)
		add_child(new_asteroid)
		asteroids.append(new_asteroid)
	pass

#function called to destroy an asteroid, spawning smaller rocks if needed 
func _asteroid_destroyed(asteroid : Asteroid):
	if(asteroid.spawnsLeft > 0):
		asteroid.spawnsLeft -= 1
		for n in asteroid.pebbleCount:
			#print("spawning pebble number " + str(n))
			var pebble : RigidBody2D = asteroid.duplicate()
			pebble.speed = asteroid.speed + asteroid.rng.randf_range(0,.3)
			pebble.spawnsLeft = asteroid.spawnsLeft	
			pebble.score = 50 if asteroid.spawnsLeft == 1 else 100
			#this is the pain point, is score just called? or is this the sign I need an asteroid manager node?
			pebble.asteroid_destroyed.connect(_asteroid_destroyed)
			pebble.scored.connect(_add_score)
			add_child(pebble)
			asteroids.append(pebble)

	asteroids.remove_at(asteroids.find(asteroid))
	print("Asteroids left: " + str(asteroids.size()));



#todo: create asteroid manager maybe? what managers do I need, what is the scope in each
