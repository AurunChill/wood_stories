extends CharacterBody2D
class_name Main

# New shared properties
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound_walk: AudioStreamPlayer2D = $sound_walk

var move_point: PointOfInterest

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var SPEED: float = 40.0
var is_looking_left: bool = false
var move_action: String = ''

var current_state: BaseNPC.States = BaseNPC.States.DEFAULT

# Character movement and state management logic
func on_default(delta):
	Input.action_release(move_action)
	move_action = ''
	_handle_movement(delta)
	_update_animation_and_sound()
	

func on_move_to_point(delta: float, point: PointOfInterest):
	var point_x = point.global_position.x
	move_action = 'left' if global_position.x > point_x else 'right'
	
	if not Input.is_action_pressed(move_action):
		Input.action_press(move_action)

	_handle_movement(delta)
	_update_animation_and_sound()
		
		
func on_enabled():
	self.current_state = BaseNPC.States.DEFAULT

func on_disabled():
	Input.action_release(move_action)
	move_action = ''
	sound_walk.stop()
	anim.play('idle')


func start_dialogue():
	Input.action_press("interact")
	Input.action_release("interact")


# Helper methods
func _handle_movement(delta: float) -> void:
	var direction: int = Input.get_axis("left", "right")
	if direction != 0:
		_update_direction(direction)
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		if not is_on_floor():
			velocity.x = 0
	
	move_and_slide()


func _update_direction(direction: int) -> void:
	is_looking_left = direction < 0
	anim.flip_h = is_looking_left


func _update_animation_and_sound() -> void:
	if velocity.x != 0:
		if not sound_walk.playing:
			sound_walk.play()
		anim.play('walk')
	else:
		sound_walk.stop()
		anim.play('idle')


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


# Engine-provided methods
func _ready():
	anim.play('idle')
	current_state = BaseNPC.States.DEFAULT
	
func _physics_process(delta):
	_apply_gravity(delta)
	match current_state:
		BaseNPC.States.DEFAULT:
			on_default(delta)
		BaseNPC.States.MOVING_TO_POINT:
			if move_point:
				on_move_to_point(delta, move_point)
		BaseNPC.States.ENABLED:
			on_enabled()
		BaseNPC.States.DISABLED:
			on_disabled()
