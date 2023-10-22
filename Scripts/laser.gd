extends Area2D

@export var speed = 400

var direction = Vector2.UP

func _ready():
    direction = Vector2.UP.rotated(rotation)

func _process(delta):
    var width = get_viewport().get_visible_rect().size.x
    var height = get_viewport().get_visible_rect().size.y
    position = position + speed * direction * delta
    if(position.x < 0 || position.x > width || position.y < 0 || position.y > height):
        print("Laser Cleanup on aisle 2")
        queue_free()
        
func _on_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
    queue_free()


func _on_body_entered(body:Node2D):
    if(body.is_in_group("asteroid")):
        body._destroyAsteroid()
        body.queue_free()
        queue_free()
