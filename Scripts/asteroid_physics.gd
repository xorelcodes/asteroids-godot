extends RigidBody2D

@export var speed = 50
@export var direction = 90
@export var spawnsPebbles = true
@export var pebbleCount = 3

var rng = RandomNumberGenerator.new()

func _ready():
	var rot = rng.randf_range(0, 2*PI)
	if( spawnsPebbles == false):
		$CollisionShape2D.shape.radius /= 2
		$Sprite2D.scale /= 2
	rotate(rot)
	apply_force(Vector2.UP.rotated(rotation) * speed)
	
	

		
		
		

func _destroyAsteroid():
	if(spawnsPebbles == true):
		for n in pebbleCount:
			print("spawning pebble number " + str(n))
			var pebble : RigidBody2D = duplicate()
			pebble.speed = speed + rng.randf_range(0,50)
			pebble.spawnsPebbles = false
			
			get_parent().add_child(pebble)

	queue_free()

func _on_body_entered(body):
	if(body.is_in_group("player")):
		body.queue_free()
		queue_free()
	
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
	
	
