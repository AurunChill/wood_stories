extends Area2D
class_name PointOfInterest

signal has_come(point)

func is_in(body: Main) -> bool:
	var collision = null
	for child in get_children():
		if child is CollisionShape2D:
			collision = child
	
	if collision:		
		var size = collision.shape.get_size()
		var left = self.global_position.x - size.x
		var right = self.global_position.x + size.x
		var up = self.global_position.y - size.y
		var down = self.global_position.y + size.y

		var x_axis = body.global_position.x > left and body.global_position.x < right
		var y_axis = body.global_position.y > up and body.global_position.y < down
		
		return x_axis and y_axis
	return false
	

func _on_body_entered(body):
	if body is Main:
		has_come.emit(self)
