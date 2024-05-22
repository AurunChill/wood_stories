extends BaseNPC
class_name Necromancer
## Class represents necromancer npc

## Necromancer is a specialized NPC character that represents a necromancer.
## This character can play idle animations and handle dialogues.

## Called when the node is added to the scene.
## Initializes animations.
func _ready():
	anim.play('idle')

## Called every physics frame.
## Handles the state for dialogues.
##
## @param delta: Time elapsed since the last frame.
func _physics_process(delta):
	match current_state:
		States.Character.READY_TO_DIALOGUE:
			on_ready_to_dialogue()

## Sets up dialogues for the Necromancer character.
## Provides two predefined dialogues for the tutorial.
## Override this method in derived characters to customize dialogues.
func setup_dialogues():
	var tutorial_dialogues = [
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.NECROMANCER, 'Ты мне не нравишься...', true),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.NECROMANCER, 'Уходи смертный', false),
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
