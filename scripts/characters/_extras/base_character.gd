extends CharacterBody2D
class_name BaseCharacter

# Shared properties
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound_walk: AudioStreamPlayer2D = $sound_walk
@onready var sound_hit: AudioStreamPlayer2D = $sound_hit

var is_player = false
var is_looking_left: bool = false
var is_hitting: bool = false

# Gravity and speed settings
@export var speed: float = 40.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_state = States.Character.DEFAULT

func play_fight_animation():
	sound_walk.stop()
	sound_hit.play()
	anim.play('fight')
	is_hitting = true
		
func handle_actions(delta: float) -> void:
	if is_hitting and anim.frame_progress == 1:
		anim.stop()
		is_hitting = false
		anim.play('lie_down')
	if Input.is_action_just_pressed('left_mouse_click'):
		if not is_hitting:
			play_fight_animation()
		
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
		if not is_hitting:
			anim.play('walk')
	else:
		sound_walk.stop()
		if not is_hitting:
			anim.play('idle')


func on_fight() -> void:
	pass


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

