extends Area2D

@export var speed = 70

var direction = Vector2.RIGHT
var is_destroyed = false

func _ready():
	direction = Vector2.RIGHT.rotated(rotation)

func _process(_delta):
	if(is_destroyed):
		queue_free()

func _physics_process(delta):
	position = position + speed * direction * delta
	#if off the screen, destroy laser. will change this to time based later
	if(position.x < 0 || position.x > GameManager.screen_width || position.y < 0 
		|| position.y > GameManager.screen_height):
        #print("Laser Cleanup on aisle 2")
		is_destroyed = true

func _on_body_entered(body:Node2D):
	#signal to the ship it's destroyed
	if(body.is_in_group("player")):
		body.ship_damaged()
		is_destroyed = true
		pass
