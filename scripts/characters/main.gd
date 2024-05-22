extends BaseCharacter
class_name Main
## Main is a character node that inherits from BaseCharacter and handles the main character's movement, state, and animations.

## Contains point of interest where main is going
var move_point: PointOfInterest
## Contains move action name 'left' or 'right'
var move_action: String
## Controls if user is lying or not (wait state)
var is_lying: bool = false
## Controls when to show sleep text ('ZZZZZZ')
var sleep_text = false

## Called when the node is added to the scene. Initializes the character's state.
func _ready():
	# Sets the character to be controlled by the player and plays the idle animation
	is_player = true
	anim.play('idle')

## Called every frame with the fixed time step. Applies gravity and handles state-based processing.
## @param delta: The time elapsed since the previous frame.
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

## Handles the default state of the character, when it is not moving to a specific point or disabled.
## @param delta: The time elapsed since the previous frame.
func on_default(delta):
	remove_sleep_text()
	
	# Release any move actions and handle new actions
	Input.action_release(move_action)
	move_action = ''
	handle_actions(delta)
	update_animation_and_sound()

## Handles the movement of the character towards a specified point.
## @param delta: The time elapsed since the previous frame.
## @param point: The target point of interest the character is moving towards.
func on_move_to_point(delta: float, point: PointOfInterest):
	remove_sleep_text()
	
	var point_x = point.global_position.x
	move_action = 'left' if global_position.x > point_x else 'right'
	
	if not Input.is_action_pressed(move_action):
		Input.action_press(move_action)
	
	handle_actions(delta)
	update_animation_and_sound()

## Handles the disabled state of the character, where the character lies down and waits.
func on_disabled():
	Input.action_release(move_action)
	move_action = ''
	
	sound_walk.stop()
	
	# Plays lie down animation if character is not already lying
	if not is_lying:
		anim.play('lie_down')
		is_lying = true
	
	# On completing lie down animation, play wait animation and display sleep text
	if is_lying and anim.frame_progress == 1:
		anim.play('wait')
		sleep_text = load("res://prefabs/interface/sleep_text.tscn").instantiate()
		add_child(sleep_text)
		sleep_text.global_position.y = global_position.y - 7

## Removes the sleep text and updates the character's lying status.
func remove_sleep_text():
	is_lying = false
	if sleep_text:
		remove_child(sleep_text)
		sleep_text = null
