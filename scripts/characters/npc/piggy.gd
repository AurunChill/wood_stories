extends BaseCharacter
class_name Piggy

# Piggy class representing a character in the game

@onready var sound_oink: AudioStreamPlayer2D = $sound_oink

var follow_character: BaseCharacter

var dir = 0

var oink_timer: float = 0
var oink_interval_min: float = 15
var oink_interval_max: float = 35


# Engine methods
func _ready():
	_on_default(0)
	follow_character = get_parent().get_node('main')
	speed = follow_character.speed
	oink_timer = randf_range(oink_interval_min, oink_interval_max)
	
	
func _physics_process(delta):
	apply_gravity(delta)
	match current_state:
		States.Character.DEFAULT:
			_on_default(delta)
		States.Character.FOLLOWING:
			_on_follow(delta)
	move_and_slide()
	
	process_background_sound(delta)


func process_background_sound(delta):
	oink_timer -= delta
	if oink_timer <= 0:
		sound_oink.play()
		oink_timer = randf_range(oink_interval_min, oink_interval_max)


func _on_default(delta):
	anim.play('idle')
	velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	
func _on_follow(delta: float):
	handle_movement(delta)
	
	if abs(follow_character.global_position.x - global_position.x) > 50:
		current_state = States.Character.DEFAULT 
	
	
func glaze_following(is_follow_left: bool) -> int:
	anim.flip_h = is_follow_left
	return -1 if is_follow_left else 1


func handle_movement(delta):
	anim.play('walk')
	velocity.x = dir * speed
		

func _on_area_2d_body_entered(body):
	if body == follow_character:
		current_state = States.Character.DEFAULT 


func _on_area_2d_body_exited(body):
	if body == follow_character:
		current_state = States.Character.FOLLOWING
		dir = glaze_following(follow_character.is_looking_left)
		
