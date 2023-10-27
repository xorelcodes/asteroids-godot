class_name  Asteroid extends RigidBody2D

signal scored(points)
signal pebble_spawn(new_pebble : Asteroid)
signal asteroid_destroyed(destroyed_asteroid: Asteroid)

@export var speed = 50
@export var direction = 90
@export var spawnsLeft = 2
@export var pebbleCount = 2
@export var score = 20

var isDestroyed = false
var rng = RandomNumberGenerator.new()
var spawnsPebbles = false
var objWidth

func _ready():
	#set random rotation/direction the asteroid will go in
	var rot = rng.randf_range(0, 2*PI)
	objWidth = $Sprite2D.texture.get_width()
	#change shape based on the stage it's in
	if( spawnsLeft < 2):
		$CollisionShape2D.shape.radius /= 1.2
		$Sprite2D.scale /= 2
	rotate(rot)
	apply_force(Vector2.UP.rotated(rotation) * speed)
	
	

func _physics_process(delta):
	_isAsteroidDestroyed()
		
		
func destroyAsteroid():
	emit_signal("scored", score)
	isDestroyed = true
		
func _isAsteroidDestroyed():
	if isDestroyed :
		emit_signal("asteroid_destroyed", self)
		queue_free()


func _on_body_entered(body):
	if(body.is_in_group("player")):
		body._ship_damaged()
		score = 0
		isDestroyed = true
	
func _integrate_forces(state):
	_wrap_screen(state)

func _wrap_screen(state):
	
	if state.transform.origin.x < -10:
		state.transform.origin.x = get_viewport_rect().size.x + 9
	if state.transform.origin.x > get_viewport_rect().size.x +10:
		state.transform.origin.x = -9
	if state.transform.origin.y < -10:
		state.transform.origin.y = get_viewport_rect().size.y  + 9
	if state.transform.origin.y > get_viewport_rect().size.y + 10:
		state.transform.origin.y = -9 
	
	
