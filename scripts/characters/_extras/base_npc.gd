extends BaseCharacter
class_name BaseNPC

# New shared properties
@onready var dialogue_area: Area2D = $DialogueArea
var dialogue_interact_text = null
var dialogue_manager = null
var dialogue_interact_created = false
var dialogue_character: BaseCharacter = null
var in_dialogue: bool = false
	
	
func setup_dialogues():
	pass
	

func on_ready_to_dialogue():
	if in_dialogue:
		return
	
	if Input.is_action_just_pressed("interact"):
		dialogue_character.current_state = States.Character.DISABLED

		if dialogue_interact_created:
			remove_child(dialogue_interact_text)
			dialogue_interact_text = null
			dialogue_interact_created = false

		dialogue_manager = load("res://prefabs/interface/dialogues/dialogue_manager.tscn").instantiate()
		setup_dialogues() # This method will be overridden in derived classes for character-specific dialogues
		add_child(dialogue_manager, true)
		dialogue_manager.start_dialogues()

		if not dialogue_manager.all_dialogues_finished.is_connected(_on_dialogue_finished):
			dialogue_manager.all_dialogues_finished.connect(_on_dialogue_finished)
		in_dialogue = true


func _on_dialogue_finished(_point):
	dialogue_character.current_state = States.Character.DEFAULT
	in_dialogue = false


func dialogue_area_entered(body):
	if body is BaseCharacter and body != self:
		current_state = States.Character.READY_TO_DIALOGUE
		
		dialogue_character = body
		
		if not dialogue_interact_created:
			dialogue_interact_text = load('res://prefabs/interface/dialogues/dialogue_interact.tscn').instantiate()
			add_child(dialogue_interact_text)
			dialogue_interact_created = true
			dialogue_interact_text.global_position = Vector2(self.global_position.x + 7,  self.global_position.y - 25)


func dialogue_area_exited(body):
	if body is BaseCharacter and body != self:
		current_state = States.Character.DEFAULT
		
		if dialogue_interact_created:
			remove_child(dialogue_interact_text)
			dialogue_interact_text = null
			dialogue_interact_created = false
			
