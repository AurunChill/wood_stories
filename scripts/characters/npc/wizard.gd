extends BaseNPC
class_name Wizard

@onready var sound_cough: AudioStreamPlayer2D = $sound_cough
var cough_timer: float = 0
var cough_interval_min: float = 10
var cough_interval_max: float = 25

func _ready():
	anim.play('idle')
	cough_timer = randf_range(cough_interval_min, cough_interval_max)
	

func _physics_process(delta):
	match current_state:
		States.Character.READY_TO_DIALOGUE:
			on_ready_to_dialogue()
	process_background_sound(delta)


func process_background_sound(delta):
	cough_timer -= delta
	if cough_timer <= 0:
		sound_cough.play()
		cough_timer = randf_range(cough_interval_min, cough_interval_max)
		

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
