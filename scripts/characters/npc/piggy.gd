extends BaseCharacter
class_name Piggy
## Class of piggy npc

## Piggy class representing a character in the game.

## A node responsible for playing the oink sound.
## Automatically initialized when the scene is loaded.
@onready var sound_oink: AudioStreamPlayer2D = $sound_oink

## The character that Piggy will follow.
var follow_character: BaseCharacter

## Direction of the piggy movement.
var dir = 0

## Timer for tracking when Piggy will oink next.
var oink_timer: float = 0

## Minimum interval between oinks, in seconds.
var oink_interval_min: float = 15

## Maximum interval between oinks, in seconds.
var oink_interval_max: float = 35

## Called when the node is added to the scene.
func _ready():
	_on_default(0)
	follow_character = get_parent().get_node('main')
	speed = follow_character.speed
	oink_timer = randf_range(oink_interval_min, oink_interval_max)
	
## Called every physics frame. `delta` is the elapsed time since the previous frame.
func _physics_process(delta):
	apply_gravity(delta)
	match current_state:
		States.Character.DEFAULT:
			_on_default(delta)
		States.Character.FOLLOWING:
			_on_follow(delta)
	move_and_slide()
	process_background_sound(delta)

## Handles the oink sound logic, reducing the timer and playing the sound when it reaches 0.
func process_background_sound(delta):
	oink_timer -= delta
	if oink_timer <= 0:
		sound_oink.play()
		oink_timer = randf_range(oink_interval_min, oink_interval_max)

## Handles the default state logic.
func _on_default(delta):
	anim.play('idle')
	velocity.x = move_toward(velocity.x, 0, speed * delta)
	
## Handles the follow state logic.
func _on_follow(delta: float):
	handle_movement(delta)
	if abs(follow_character.global_position.x - global_position.x) > 50:
		current_state = States.Character.DEFAULT 

## Sets the direction for follow behavior and flips the animation accordingly.
## @param is_follow_left: A boolean indicating if movement is to the left.
## @return: int The direction of the movement, -1 for left and 1 for right.
func glaze_following(is_follow_left: bool) -> int:
	anim.flip_h = is_follow_left
	return -1 if is_follow_left else 1

## Handles the movement logic.
func handle_movement(delta):
	anim.play('walk')
	velocity.x = dir * speed

## Called when a body enters the 2D area.
func _on_area_2d_body_entered(body):
	if body == follow_character:
		current_state = States.Character.DEFAULT 

## Called when a body exits the 2D area.
func _on_area_2d_body_exited(body):
	if body == follow_character:
		current_state = States.Character.FOLLOWING
		dir = glaze_following(follow_character.is_looking_left)
