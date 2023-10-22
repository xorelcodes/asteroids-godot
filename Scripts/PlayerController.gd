extends RigidBody2D
@export var impulse_strength = 50
@export var rotation_speed = TAU

var lasers = preload("res://Scenes/Actors/laser.tscn")

func _ready():
    pass

func _process(delta):
    if(Input.is_action_just_pressed("fire")):
        var laser = lasers.instantiate()
        laser.position = position
        laser.rotation = rotation
        get_parent().add_child(laser)

func _physics_process(delta):
    angular_velocity = 0
    if(Input.is_action_pressed("up")):
        apply_force(Vector2.UP.rotated(rotation) * impulse_strength)
    if(Input.is_action_pressed("right")):
        angular_velocity = rotation_speed
    if(Input.is_action_pressed("left")):
        angular_velocity = -rotation_speed


func _integrate_forces(state):
    wrap_screen(state)

func wrap_screen(state):
    
    if state.transform.origin.x < 0:
        state.transform.origin.x = get_viewport_rect().size.x
    if state.transform.origin.x > get_viewport_rect().size.x:
        state.transform.origin.x = 0

    if state.transform.origin.y < 0:
        state.transform.origin.y = get_viewport_rect().size.y
    if state.transform.origin.y > get_viewport_rect().size.y:
        state.transform.origin.y = 0
    