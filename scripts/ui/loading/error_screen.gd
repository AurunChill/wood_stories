extends Control

var show_time = 5.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	show_time -= delta
	
	if show_time < 0:
		get_parent().remove_child(self)
