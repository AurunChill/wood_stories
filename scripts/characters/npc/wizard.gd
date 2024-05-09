extends BaseNPC
class_name Wizard

func _ready():
	anim.play('idle')
	

func _physics_process(delta):
	match current_state:
		States.Character.READY_TO_DIALOGUE:
			on_ready_to_dialogue()

# Override setup_dialogues in derived characters
func setup_dialogues():
	var tutorial_dialogues = [
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.WIZARD, 'Что мне делать?', true),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.WIZARD, 'Видишь окно ввода слева вверху?', false),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.WIZARD, 'Отправь описания сценария которое хочешь увидеть и подожди около минуты', false),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.WIZARD, 'Ясно, спасибо!', true),
	]
	for dialogue in tutorial_dialogues:
		self.dialogue_manager.add_to_queue(dialogue)


func _on_dialogue_area_body_entered(body):
	"""
	Triggers when another body (character) enters the dialogue interaction area, setting the state to READY_TO_DIALOGUE.
	"""
	dialogue_area_entered(body)


func _on_dialogue_area_body_exited(body):
	"""
	Reverts the state to DEFAULT when another character leaves the dialogue interaction area, indicating the end of potential for dialogue interaction.
	"""
	dialogue_area_exited(body)
