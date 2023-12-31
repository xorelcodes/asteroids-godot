extends Area2D

@export var speed = 400

var direction = Vector2.UP

var time_to_live : Timer

func _ready():
	direction = Vector2.UP.rotated(rotation)

func _process(delta):
	pass
	position = position + speed * direction * delta
	GameManager.wrap_screen_projectile(self, 1)
	#if off the screen, destroy laser. will change this to time based later
	#if(position.x < 0 || position.x > GameManager.screen_width || position.y < 0 
		#|| position.y > GameManager.screen_height):
		#print("Laser Cleanup on aisle 2")
		#queue_free()

func _on_body_entered(body:Node2D):
	#signal to the asteroid it's destroyed
	if(body.is_in_group("asteroid")):
		body.destroyAsteroid()
		queue_free()

func _on_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int):
	print("i'm in an area")
	if(area.is_in_group("ufo")):
		area.ship_hit()
		queue_free()


func _on_timer_timeout():
	queue_free()
