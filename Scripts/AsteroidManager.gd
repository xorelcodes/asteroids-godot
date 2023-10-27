extends Node


@export var number_of_starting_asteroids = 3

var asteroids = []
var asteroid_template = preload("res://Scenes/Actors/asteroid.tscn")


var screen_width
var screen_height

var rng = RandomNumberGenerator.new()

func _enter_tree():
	GameManager.spawn_init_asteroids.connect(_spawn_init_asteroids)

func _ready():
	#get screen height and width for later spawn calculations 
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
	

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
		#new_asteroid.scored.connect(_add_score)
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
			#fix add score connection
			#pebble.scored.connect(_add_score)
			add_child(pebble)
			asteroids.append(pebble)

	asteroids.remove_at(asteroids.find(asteroid))
	print("Asteroids left: " + str(asteroids.size()));

