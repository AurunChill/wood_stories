extends BaseNPC
class_name KnightWoman
## Class represents knight npc

## KnightWoman is a specialized NPC character that represents a knight woman.
## This character can look at other characters, play background sounds, 
## and handle dialogues.

## The character the KnightWoman is looking at.
var looking_at: BaseCharacter

## A whistle sound node in the scene linked via the editor.
## Automatically initialized when the scene is loaded.
@onready var whistle_sound: AudioStreamPlayer2D = $sound_whistle

## Timer to track when to play the whistle sound.
var whistle_timer: float = 0

## Minimum interval between whistles in seconds.
var whistle_interval_min: float = 10

## Maximum interval between whistles in seconds.
var whistle_interval_max: float = 25

## Called when the node is added to the scene.
## Initializes animations and sets the character to look at.
func _ready():
	anim.play('idle')
	looking_at = get_parent().get_node('main')

## Called every physics frame.
## Updates the direction and processes background sounds.
##
## @param delta: Time elapsed since the last frame.
func _physics_process(delta):
	handle_look_dir()
	match current_state:
		States.Character.READY_TO_DIALOGUE:
			on_ready_to_dialogue()
	process_background_sound(delta)

## Handles the direction that the KnightWoman is looking at
## by flipping the animation based on the position.
func handle_look_dir():
	if looking_at.global_position.x > global_position.x:
		anim.flip_h = false
	else:
		anim.flip_h = true


## Processes the background sound by checking the whistle timer
## and playing the whistle sound when the timer reaches zero.
## 
## @param delta: Time elapsed since the last frame.
func process_background_sound(delta):
	whistle_timer -= delta
	if whistle_timer <= 0:
		whistle_sound.play()
		whistle_timer = randf_range(whistle_interval_min, whistle_interval_max)

## Sets up dialogues for the KnightWoman character.
## Provides two predefined dialogues for the tutorial.
## Override this method in derived characters to customize dialogues.
func setup_dialogues():
	var tutorial_dialogues = [
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.KNIGHT, 'Привет!', true),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.KNIGHT, 'Здравствуй, храбрый друг', false),
	]
	for dialogue in tutorial_dialogues:
		self.dialogue_manager.add_to_queue(dialogue)

## Callback function called when a body enters the dialogue area.
##
## @param body: The body that entered the dialogue area.
func _on_dialogue_area_body_entered(body):
	dialogue_area_entered(body)

## Callback function called when a body exits the dialogue area.
##
## @param body: The body that exited the dialogue area.
func _on_dialogue_area_body_exited(body):
	dialogue_area_exited(body)
