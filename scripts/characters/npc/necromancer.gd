extends BaseNPC
class_name Necromancer


func _ready():
	anim.play('idle')
	

func _physics_process(delta):
	match current_state:
		States.Character.READY_TO_DIALOGUE:
			on_ready_to_dialogue()
			
			
# Override setup_dialogues in derived characters
func setup_dialogues():
	var tutorial_dialogues = [
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.NECROMANCER, 'Ты мне не нравишься...', true),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.NECROMANCER, 'Уходи смертный', false),
	]
	for dialogue in tutorial_dialogues:
		self.dialogue_manager.add_to_queue(dialogue)
		

func _on_dialogue_area_body_entered(body):
	dialogue_area_entered(body)


func _on_dialogue_area_body_exited(body):
	dialogue_area_exited(body)
