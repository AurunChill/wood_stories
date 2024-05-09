extends BaseCharacter
class_name Main

var move_point: PointOfInterest
var move_action: String
var is_lying: bool = false
var sleep_text = false

func _ready():
	is_player = true
	anim.play('idle')


func _physics_process(delta):
	apply_gravity(delta)
	match current_state:
		States.Character.DEFAULT:
			on_default(delta)
		States.Character.MOVING_TO_POINT:
			if move_point:
				on_move_to_point(delta, move_point)
		States.Character.DISABLED:
			on_disabled()
		States.Character.FIGHT:
			on_fight()
	

func on_default(delta):
	remove_sleep_text()
		
	Input.action_release(move_action)
	move_action = ''
	handle_actions(delta)
	update_animation_and_sound()


func on_move_to_point(delta: float, point: PointOfInterest):
	remove_sleep_text()
		
	var point_x = point.global_position.x
	move_action = 'left' if global_position.x > point_x else 'right'
	
	if not Input.is_action_pressed(move_action):
		Input.action_press(move_action)
	
	handle_actions(delta)
	update_animation_and_sound()
	

func on_disabled():
	Input.action_release(move_action)
	move_action = ''
	
	sound_walk.stop()
	if not is_lying:
		anim.play('lie_down')
		is_lying = true
	if is_lying and anim.frame_progress == 1:
		anim.play('wait')
		sleep_text = load("res://prefabs/interface/sleep_text.tscn").instantiate()
		add_child(sleep_text)
		sleep_text.global_position.y = global_position.y - 7
		


func remove_sleep_text():
	is_lying = false
	if sleep_text:
		remove_child(sleep_text)
		sleep_text = null
