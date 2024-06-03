extends Area2D
class_name PointOfInterest
## Respresents Area where user can find something interesting

## Signal emitted when a body of type `Main` enters the area.
## Contains the point (self) as its argument.
signal has_come(point)

## Checks if the specified `Main` body is within the collision shape area of this node.
##
## @param body: The `Main` type body to be checked.
## @return: `true` if the body is within the collision area, `false` otherwise.
func has(body: Main) -> bool:
	var collision = null
	# Iterate over the children nodes to find a CollisionShape2D
	for child in get_children():
		if child is CollisionShape2D:
			collision = child
	
	if collision:
		# Calculate the bounds of the collision area based on the shape's size
		var size = collision.shape.get_size()
		var left = self.global_position.x - size.x
		var right = self.global_position.x + size.x
		var up = self.global_position.y - size.y
		var down = self.global_position.y + size.y

		# Check if the body's global position lies within the collision bounds
		var x_axis = body.global_position.x > left and body.global_position.x < right
		var y_axis = body.global_position.y > up and body.global_position.y < down
		
		return x_axis and y_axis
	return false
	

## Callback function that gets called when a body enters the area.
## If the body is of type `Main`, it emits the `has_come` signal.
##
## @param body: The body that entered the area.
## @return: void
func _on_body_entered(body):
	if body is Main:
		has_come.emit(self)
