extends Area2D

@export var speed = 400

var direction = Vector2.UP

func _ready():
	direction = Vector2.UP.rotated(rotation)

func _process(delta):
	position = position + speed * direction * delta
	#if off the screen, destroy laser. will change this to time based later
	if(position.x < 0 || position.x > GameManager.screen_width || position.y < 0 
		|| position.y > GameManager.screen_height):
        #print("Laser Cleanup on aisle 2")
		queue_free()

func _on_body_entered(body:Node2D):
	#signal to the asteroid it's destroyed
	if(body.is_in_group("asteroid")):
		body.destroyAsteroid()
		queue_free()
