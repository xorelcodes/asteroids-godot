extends Area2D

@export var speed = 50
@export var direction = 0


func _on_body_shape_entered(body_rid:RID, body:Node2D, body_shape_index:int, local_shape_index:int):
    if(body.is_in_group("player")):
        body.queue_free()
    queue_free()

func _on_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
    queue_free()
