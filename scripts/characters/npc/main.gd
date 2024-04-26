extends BaseCharacter
class_name Main

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED: float = 40.0
var is_looking_left: bool = false

# Base character methods
func on_default(delta):
	_handle_movement(delta)
	_update_animation()
		
func on_enabled():
	self.current_state = BaseCharacter.States.DEFAULT

func on_disabled():
	anim.play('idle')


# Extra methods
func _handle_movement(delta: float) -> void:
	"""
	Calculates and applies the player's movement based on input.
	"""
	var direction: int = Input.get_axis("left", "right")
	if direction != 0:
		_update_direction(direction)
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		if not is_on_floor():
			velocity.x = 0
	
	move_and_slide()
	

	#move_and_slide()


func _update_direction(direction: int) -> void:
	"""
	Updates the player's facing direction.
	"""
	is_looking_left = direction < 0
	anim.flip_h = is_looking_left


func _update_animation() -> void:
	"""
	Updates the player's animation based on current movement and state.
	"""
	if velocity.x != 0:
		anim.play('walk')
	else:
		anim.play('idle')


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


# Engine methods
func _ready():
	anim.play('idle')
	current_state = BaseCharacter.States.DEFAULT
	
func _physics_process(delta):
	_apply_gravity(delta)
	match current_state:
		BaseCharacter.States.DEFAULT:
			on_default(delta)
		BaseCharacter.States.READY_TO_DIALOGUE:
			on_ready_to_dialogue()
		BaseCharacter.States.ENABLED:
			on_enabled()
		BaseCharacter.States.DISABLED:
			on_disabled()
		
