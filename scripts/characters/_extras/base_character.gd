extends CharacterBody2D
class_name BaseCharacter
## BaseCharacter is a character node that extends CharacterBody2D.
## It handles the movement, animations, and sounds of a character in a game.

## An animated sprite node in the scene linked via the editor.
## Automatically initialized when the scene is loaded.
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

## An audio stream player node for walk sound linked via the editor.
@onready var sound_walk: AudioStreamPlayer2D = $sound_walk

## An audio stream player node for hit sound linked via the editor.
@onready var sound_hit: AudioStreamPlayer2D = $sound_hit

## Determines if the character is controlled by the player.
var is_player = false

## Determines if the character is looking to the left.
var is_looking_left: bool = false

## Determines if the character is in the hitting state.
var is_hitting: bool = false

## Speed of the character.
@export var speed: float = 40.0

## Gravity value for the character.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

## Represents the current state of the character.
var current_state = States.Character.DEFAULT

## Plays the fight animation and sound.
## Sets the is_hitting flag to true.
func play_fight_animation():
	sound_walk.stop()
	sound_hit.play()
	anim.play('fight')
	is_hitting = true
		
## Handles player input actions for movement.
## Updates the character's direction and velocity based on input.
##
## @param delta: The frame's time delta.
## @return: void
func handle_actions(delta: float) -> void:
	var direction: int = Input.get_axis("left", "right")
	if direction != 0:
		update_direction(direction)
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		if not is_on_floor():
			velocity.x = 0
	move_and_slide()

## Updates the character's direction based on input direction.
##
## @param direction: The direction of movement (-1 for left, 1 for right).
## @return: void
func update_direction(direction: int) -> void:
	is_looking_left = direction < 0
	anim.flip_h = is_looking_left

## Updates the animation and sound based on the character's velocity.
## Plays walk animation and sound if character is moving,
## otherwise plays idle animation and stops the walk sound.
##
## @return: void
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

## Placeholder for handling fight state.
##
## @return: void
func on_fight() -> void:
	pass

## Applies gravity to the character.
## Increments the character's vertical velocity if it is not on the floor.
##
## @param delta: The frame's time delta.
## @return: void
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
