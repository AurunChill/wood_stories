extends BaseNPC
class_name Wizard
## Code of wizard npc

## A node responsible for playing the cough sound.
## Automatically initialized when the scene is loaded.
@onready var sound_cough: AudioStreamPlayer2D = $sound_cough

## Timer for tracking when the wizard will cough next.
var cough_timer: float = 0

## Minimum interval between coughs, in seconds.
var cough_interval_min: float = 10

## Maximum interval between coughs, in seconds.
var cough_interval_max: float = 25

# Called when the node is added to the scene.
func _ready():
	# Start the idle animation and set the initial cough timer
	anim.play('idle')
	cough_timer = randf_range(cough_interval_min, cough_interval_max)
	

# Called every physics frame. `delta` is the elapsed time since the previous frame.
func _physics_process(delta):
	match current_state:
		States.Character.READY_TO_DIALOGUE:
			on_ready_to_dialogue()
	process_background_sound(delta)

# Handles the cough sound logic, reducing the timer and playing the sound when it reaches 0.
func process_background_sound(delta):
	cough_timer -= delta
	if cough_timer <= 0:
		sound_cough.play()
		cough_timer = randf_range(cough_interval_min, cough_interval_max)

## Sets up the dialogues for the wizard.
# This function should be overridden in derived characters.
func setup_dialogues():
	var tutorial_dialogues = [
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.WIZARD, 'Что мне делать?', true),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.WIZARD, 'Видишь окно ввода слева вверху?', false),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.WIZARD, 'Отправь описания сценария которое хочешь увидеть и подожди около минуты', false),
		Dialogue.new(Dialogue.Roles.MAIN, Dialogue.Roles.WIZARD, 'Ясно, спасибо!', true),
	]
	for dialogue in tutorial_dialogues:
		self.dialogue_manager.add_to_queue(dialogue)

# Called when a body enters the dialogue area.
func _on_dialogue_area_body_entered(body):
	dialogue_area_entered(body)

# Called when a body exits the dialogue area.
func _on_dialogue_area_body_exited(body):
	dialogue_area_exited(body)
