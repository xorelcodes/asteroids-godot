class_name  Asteroid extends RigidBody2D

@export var speed = 50
@export var direction = 90
@export var spawnsLeft = 2
@export var pebbleCount = 2
@export var points = 20

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

func _physics_process(_delta):
	_isAsteroidDestroyed()
			
func destroyAsteroid():
	isDestroyed = true
		
func _isAsteroidDestroyed():
	if isDestroyed :
		Signals.emit_signal("asteroid_destroyed", self)
		queue_free()

func _on_body_entered(body):
	if(body.is_in_group("player")):
		body.ship_damaged()
		points = 0
		isDestroyed = true
	
func _integrate_forces(state):
	GameManager.wrap_screen(state, 10)

