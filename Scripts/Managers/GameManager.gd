extends Node

@export var lives_left = 3
@export var high_score = 1000

signal spawn_player()
signal spawn_init_asteroids()
signal laser_hit(hit_asteroid : Asteroid)

var screen_width
var screen_height
var total_score: int

var rng = RandomNumberGenerator.new()

func _enter_tree():
	#get screen height and width for later spawn calculations 
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y

func _ready():
	emit_signal("spawn_player")
	emit_signal("spawn_init_asteroids")
	pass

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


#checking for incoming object, no matter type,
#hitting edge of screen boundaries, move it to the opposite side if so
func wrap_screen(state, buffer):
	var spawnPoint = buffer - 1
	if state.transform.origin.x < -buffer:
		state.transform.origin.x = screen_width + spawnPoint
	if state.transform.origin.x > screen_width +buffer:
		state.transform.origin.x = -spawnPoint
	if state.transform.origin.y < -buffer:
		state.transform.origin.y = screen_height  + spawnPoint
	if state.transform.origin.y > screen_height + buffer:
		state.transform.origin.y = -spawnPoint 
	
func _process(delta):
	if(Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
