extends RigidBody2D


func _on_body_shape_entered(body_rid:RID, body:Node, body_shape_index:int, local_shape_index:int):
	if(body.is_in_group("player")):
		body.queue_free()
		queue_free()
	if body.is_in_group("projectile"):
		queue_free()