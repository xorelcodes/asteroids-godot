extends Node

@export var lives_left = 3
@export var high_score = 1000

signal spawn_player()
signal spawn_init_asteroids()


var player1
var screen_width
var screen_height

var rng = RandomNumberGenerator.new()


var total_score: int
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




func _process(delta):
	if(Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()

#todo: create asteroid manager maybe? what managers do I need, what is the scope in each
