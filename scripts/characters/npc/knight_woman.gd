extends BaseNPC
class_name KnightWoman

var looking_at: BaseCharacter

func _ready():
	anim.play('idle')
	looking_at = get_parent().get_node('main')
	

func handle_look_dir():
	if looking_at.global_position.x > global_position.x:
		anim.flip_h = false
	else:
		anim.flip_h = true
	

func _physics_process(delta):
	handle_look_dir()
	match current_state:
		States.Character.READY_TO_DIALOGUE:
			on_ready_to_dialogue()

# Override setup_dialogues in derived characters
func setup_dialogues():
	var tutorial_dialogues = [
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.KNIGHT, 'Привет женщина', true),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.KNIGHT, 'Биба боба', false),
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
