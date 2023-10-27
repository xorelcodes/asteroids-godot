extends Node

@export var default_lives = 2
@export var high_score = 1000

signal new_game_started
signal level_over
signal game_over_hit
signal respawn
signal restart_game
signal start_next_level
signal score_changed(new_score : String)
signal lives_changed(new_lives : String)

var current_lives = 2
var screen_width
var screen_height
var total_score: int
var dead = false
var game_over = false
var level_complete = false

#reference to player 1. might delete this, not sure if needed or good design
#seems bad to have in the overall game manager
var player1

var rng = RandomNumberGenerator.new()

func _enter_tree():
	#get screen height and width for later spawn calculations 
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y

func _ready():
	_new_game()
	
func _new_game():
	emit_signal("new_game_started")


#add to total score
func add_score(points : int):
	total_score += points
	emit_signal("score_changed", str(total_score).pad_zeros(6))
	#print("Total Score: " + str(total_score))

func level_cleared():
	level_complete = true
	emit_signal("level_over")


#lose a life, game over on 0 lives
func lose_life():
	if(current_lives == 0):
		game_over = true
		emit_signal("game_over_hit")
		return
	current_lives -= 1
	dead = true
	emit_signal("lives_changed", "x" + str(current_lives))

func ready_player1(ship : PlayerShip):
	player1 = ship

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
		#get_tree().reload_current_scene()
		emit_signal("start_next_level")
	if(Input.is_action_just_pressed("fire")):
		if(SceneManager.current_scene_type == Constants.SceneType.TITLE_SCREEN || level_complete):
			level_complete = false
			emit_signal("start_next_level")
			return
		if(game_over):
			dead = false
			game_over = false
			current_lives = default_lives
			emit_signal("restart_game")
			return
		if(dead):
			dead = false
			emit_signal("respawn")	
			return
		if(SceneManager.current_scene_type == Constants.SceneType.CREDITS):
			dead = false
			game_over = false
			current_lives = default_lives
			total_score = 0
			emit_signal("restart_game")
			return
		
