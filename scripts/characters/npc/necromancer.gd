extends BaseNPC
class_name Necromancer

# Override setup_dialogues in derived characters
func setup_dialogues():
	var tutorial_dialogues = [
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.NECROMANCER, 'Ты мне не нравишься...', true),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.NECROMANCER, 'Пошел отсюда', false),
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
