extends RigidBody2D

signal ship_destroyed

@export var impulse_strength = 50
@export var rotation_speed = TAU

var lasers = preload("res://Scenes/Actors/laser.tscn")
var ship_hit= false

func _ready():
	pass

func _process(delta):
	#fire and instantiate a laser on each press. TODO make it so it fires if held down in intervals. Add an export variable for interval
	if(Input.is_action_just_pressed("fire")):
		var laser = lasers.instantiate()
		laser.position = position
		laser.rotation = rotation
		get_parent().add_child(laser)

func _physics_process(delta):
	#call a check to see if ship is destroyed every physics frame 
	_isShipDestroyed()
	#reset angular velocity to 0 for better ship handling
	angular_velocity = 0
	_input_handling()

#check every physic frame to see if ship is destroyed, if so emit a signal that it has been destroyed, and destroy this object
func _isShipDestroyed():
	if ship_hit:
		emit_signal("ship_destroyed")
		queue_free()

func _input_handling():
	#impule forward
	if(Input.is_action_pressed("up")):
		apply_force(Vector2.UP.rotated(rotation) * impulse_strength)
	if(Input.is_action_pressed("right")):
		angular_velocity = rotation_speed
	if(Input.is_action_pressed("left")):
		angular_velocity = -rotation_speed

#call from outside object telling the ship it is dealt damage (future could include a damage amount, ex for shields or hull health)
func ship_damaged():
	ship_hit = true

func _integrate_forces(state):
	GameManager.wrap_screen(state, 3)

