extends Control

@export var score_display : Label
@export var lives_display : Label
@export var respawn_display : Label
@export var game_over_display : Label
@export var success_display : Label

func _enter_tree():
	GameManager.score_changed.connect(_update_score_display)
	GameManager.lives_changed.connect(_update_lives_display)
	GameManager.game_over_hit.connect(_show_game_over)
	GameManager.respawn.connect(_hide_messages)
	SceneManager.spawn_player.connect(_hide_messages)
	GameManager.level_over.connect(_show_next_level)

func _ready():
	lives_display.text = "x" + str(GameManager.current_lives)
	score_display.text = str(GameManager.total_score).pad_zeros(6)
	pass

func _update_score_display(new_score : String):
	score_display.text = new_score

func _update_lives_display(new_lives : String):
	lives_display.text = new_lives
	respawn_display.visible = true;

func _show_game_over():
	game_over_display.visible = true

func _show_next_level():
	success_display.visible = true

func _hide_messages():
	print("hit here")
	respawn_display.visible = false
	game_over_display.visible = false
	success_display.visible = false
