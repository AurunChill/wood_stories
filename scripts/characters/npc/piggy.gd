extends CharacterBody2D
class_name Piggy

# Piggy class representing a character in the game

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound_oink: AudioStreamPlayer2D = $sound_oink

var follow_character: BaseCharacter

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed: float
var dir = 0

var oink_timer: float = 0
var oink_interval_min: float = 15
var oink_interval_max: float = 35

# Define the states Piggy can be in
enum States {
	FOLLOWING,
	STANDING	
}
var current_state = States.STANDING


func _stand(delta):
	"""
	Stand in place by playing idle animation and gradually reducing velocity to 0.
	"""
	anim.play('idle')
	velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	
func _follow(delta: float):
	"""
	Follow the main character by moving towards their position and changing state to STANDING if the distance is greater than 50.
	"""
	_move(delta, dir)
	
	if abs(follow_character.global_position.x - global_position.x) > 50:
		current_state = States.STANDING
	
	
func _update_direction(is_follow_left: bool) -> int:
	"""
	Update the direction based on whether Piggy is following to the left or right.
	"""
	anim.flip_h = is_follow_left
	return -1 if is_follow_left else 1


func _move(delta, dir):
	"""
	Move Piggy in the specified direction by playing walk animation and adjusting velocity.
	"""
	anim.play('walk')
	velocity.x = dir * speed
	


func _apply_gravity(delta: float) -> void:
	"""
	Apply gravity to Piggy to simulate realistic vertical movement.
	"""
	if not is_on_floor():
		velocity.y += gravity * delta


# Engine methods
func _ready():
	"""
	Called when the Node is added to the scene tree for the first time.
	Initialize Piggy's properties with those of the main character.
	"""
	_stand(0)
	follow_character = get_parent().get_node('main')
	speed = follow_character.speed
	oink_timer = randf_range(oink_interval_min, oink_interval_max)
	
	
func _physics_process(delta):
	"""
	Called every physics frame.
	Apply gravity, update the state based on conditions, move Piggy accordingly, and handle oink timer.
	"""
	_apply_gravity(delta)
	match current_state:
		States.STANDING:
			_stand(delta)
		States.FOLLOWING:
			_follow(delta)
	move_and_slide()
	
	oink_timer -= delta
	if oink_timer <= 0:
		# Play oink sound and reset timer
		sound_oink.play()
		oink_timer = randf_range(oink_interval_min, oink_interval_max)
		

func _on_area_2d_body_entered(body):
	"""
	Handle the event when Piggy enters a physics body area (e.g., the main character).
	Update Piggy's state to STANDING.
	"""
	if body == follow_character:
		current_state = States.STANDING


func _on_area_2d_body_exited(body):
	"""
	Handle the event when Piggy exits a physics body area (e.g., the main character).
	Update Piggy's state to FOLLOWING.
	"""
	if body == follow_character:
		current_state = States.FOLLOWING
		dir = _update_direction(follow_character.is_looking_left)
		
