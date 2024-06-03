extends BaseCharacter
class_name BaseNPC
## BaseNPC is a character node that extends BaseCharacter.
## It handles dialogues of a character in a game.

## A node representing the dialogue area
@onready var dialogue_area: Area2D = $DialogueArea
## Text displayed when the player can interact for dialogue
var dialogue_interact_text = null
## Manager responsible for handling dialogues
var dialogue_manager = null
## Flag to indicate whether the dialogue interact text has been created
var dialogue_interact_created: bool = false
## The character currently interacting for dialogue
var dialogue_character: BaseCharacter = null
## Flag to indicate if the NPC is currently in a dialogue
var in_dialogue: bool = false

## Sets up the dialogues for the NPC.
## This method is meant to be overridden in derived classes to provide specific dialogues.
func setup_dialogues():
	pass

## Checks if the NPC is ready to start a dialogue.
## If the "interact" action is just pressed, it disables the current state of `dialogue_character`,
## sets up and starts the dialogue manager, and connects the dialogue finished signal.
func on_ready_to_dialogue():
	if in_dialogue:
		return
	
	if Input.is_action_just_pressed("interact"):
		dialogue_character.current_state = States.Character.DISABLED

		if dialogue_interact_created:
			remove_child(dialogue_interact_text)
			dialogue_interact_text = null
			dialogue_interact_created = false

		# Load and instantiate the dialogue manager, which handles all dialogue interactions
		dialogue_manager = load("res://prefabs/interface/dialogues/dialogue_manager.tscn").instantiate()
		setup_dialogues() # This method will be overridden in derived classes for character-specific dialogues
		add_child(dialogue_manager, true)
		dialogue_manager.start_dialogues()

		# Connect the dialogue finished signal to the appropriate method
		if not dialogue_manager.all_dialogues_finished.is_connected(_on_dialogue_finished):
			dialogue_manager.all_dialogues_finished.connect(_on_dialogue_finished)
		in_dialogue = true

## Handler for when all dialogues are finished.
## This method resets the current state of `dialogue_character` and the `in_dialogue` flag.
##
## @param _point: Unused argument from the signal connection.
func _on_dialogue_finished(_point):
	dialogue_character.current_state = States.Character.DEFAULT
	in_dialogue = false

## Called when a body enters the dialogue area.
## If the body is a different `BaseCharacter`, it sets up the dialogue interact text.
##
## @param body: The body that entered the dialogue area.
func dialogue_area_entered(body):
	if body is BaseCharacter and body != self:
		current_state = States.Character.READY_TO_DIALOGUE
		
		dialogue_character = body

		# Check if the dialogue interact text has not been created and create it
		if not dialogue_interact_created:
			dialogue_interact_text = load('res://prefabs/interface/dialogues/dialogue_interact.tscn').instantiate()
			add_child(dialogue_interact_text)
			dialogue_interact_created = true
			dialogue_interact_text.global_position = Vector2(self.global_position.x + 7,  self.global_position.y - 25)

## Called when a body exits the dialogue area.
## If the body is a different `BaseCharacter`, it removes the dialogue interact text.
##
## @param body: The body that exited the dialogue area.
func dialogue_area_exited(body):
	if body is BaseCharacter and body != self:
		current_state = States.Character.DEFAULT
		
		# Check if the dialogue interact text has been created and remove it
		if dialogue_interact_created:
			remove_child(dialogue_interact_text)
			dialogue_interact_text = null
			dialogue_interact_created = false
