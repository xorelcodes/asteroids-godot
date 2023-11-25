extends Node


var levels : Array[PackedScene] = []
var default_level : int = 0
var win_screen = preload("res://Scenes/Levels/Level_Win.tscn")

#default level will be the main menu
var current_scene_id = 0
var previous_scene_id = 0

var current_scene
var level_count = 0

var infinite_level_number = 0

var current_scene_type = Constants.SceneType.TITLE_SCREEN
#func _ready():
	#pass

func _enter_tree():
	_connect_signals()
	_add_levels()


func _connect_signals():
	Signals.new_game_started.connect(_new_game)
	Signals.start_next_level.connect(_next_level)
	Signals.restart_game.connect(_game_over)

func _add_levels():
	levels.append(preload("res://Scenes/Levels/Level_Title.tscn"))
	levels.append(preload("res://Scenes/Levels/Level_1.tscn"))
	levels.append(preload("res://Scenes/Levels/Level_2.tscn"))
	level_count = levels.size()

func _new_game():
	current_scene_id = default_level
	current_scene_type = Constants.SceneType.TITLE_SCREEN
	current_scene = levels[current_scene_id].instantiate()
	print(levels.size())
	add_child(current_scene)


func _next_level():
	previous_scene_id = current_scene_id
	current_scene_id += 1
	current_scene_type = Constants.SceneType.GAME_SCREEN
	current_scene.queue_free()
	current_scene = preload("res://Scenes/Levels/Level_1.tscn").instantiate()
	add_child(current_scene)
	Signals.emit_signal("spawn_player")
	Signals.emit_signal("spawn_init_asteroids")

	

func _game_over():
	current_scene.queue_free()
	current_scene_id = default_level
	current_scene_type = Constants.SceneType.TITLE_SCREEN
	current_scene = levels[current_scene_id].instantiate()
	print(levels.size())
	add_child(current_scene)
