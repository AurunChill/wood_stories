extends BaseCharacter
class_name Main

var move_point: PointOfInterest
var move_action: String


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
	Input.action_release(move_action)
	move_action = ''
	handle_actions(delta)
	update_animation_and_sound()


func on_move_to_point(delta: float, point: PointOfInterest):
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
	anim.play('lie_down')
