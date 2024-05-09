extends CharacterBody2D
class_name BaseCharacter

# Shared properties
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound_walk: AudioStreamPlayer2D = $sound_walk

var is_player = false
var is_looking_left: bool = false

# Gravity and speed settings
@export var speed: float = 40.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_state = States.Character.DEFAULT


func handle_movement(delta: float) -> void:
	var direction: int = Input.get_axis("left", "right")
	if direction != 0:
		update_direction(direction)
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		if not is_on_floor():
			velocity.x = 0
	move_and_slide()


func update_direction(direction: int) -> void:
	is_looking_left = direction < 0
	anim.flip_h = is_looking_left


func update_animation_and_sound() -> void:
	if velocity.x != 0:
		if not sound_walk.playing:
			sound_walk.play()
		anim.play('walk')
	else:
		sound_walk.stop()
		anim.play('idle')


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
