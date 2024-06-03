extends Control
class_name ErrorScreen
## Managing error screen

## The amount of time (in seconds) the error screen should be visible.
## This value will be decremented each frame.
var show_time: float = 5.0


## Called every frame. 'delta' is the elapsed time since the previous frame.
##
## @param delta: The elapsed time since the previous frame (in seconds).
## @return: void
func _process(delta: float):
	# Decrement the show_time by the elapsed time (delta).
	show_time -= delta
	
	# If show_time is less than 0, remove this node from its parent.
	if show_time < 0:
		get_parent().remove_child(self)
