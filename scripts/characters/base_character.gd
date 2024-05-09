extends CharacterBody2D
class_name BaseNPC

# State
enum States {
	DEFAULT,
	ENABLED,
	DISABLED,
	MOVING_TO_POINT,
	READY_TO_DIALOGUE,
}
var current_state: States = States.DEFAULT

# New shared properties
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogue_area: Area2D = $DialogueArea
var dialogue_interact = null
var dialogue_manager = null
var dialogue_interact_created = false
var dialogue_character: Main = null
var in_dialogue: bool = false


func _ready():
	anim.play('idle')
	

func _physics_process(delta):
	match current_state:
		States.DEFAULT:
			on_default(delta)
		States.READY_TO_DIALOGUE:
			on_ready_to_dialogue()
		States.ENABLED:
			on_enabled()
		States.DISABLED:
			on_disabled()
			

func on_default(delta):
	pass
	

func on_move_to_point(delta: float, point: PointOfInterest):
	pass
	

func on_ready_to_dialogue():
	if in_dialogue:
		return
	
	if Input.is_action_just_pressed("interact"):
		dialogue_character.current_state = States.DISABLED

		if dialogue_interact_created:
			remove_child(dialogue_interact)
			dialogue_interact = null
			dialogue_interact_created = false

		dialogue_manager = load("res://prefabs/interface/dialogues/dialogue_manager.tscn").instantiate()
		setup_dialogues() # This method will be overridden in derived classes for character-specific dialogues
		add_child(dialogue_manager, true)
		dialogue_manager.start_dialogues()

		if not dialogue_manager.all_dialogues_finished.is_connected(_on_dialogue_finished):
			dialogue_manager.all_dialogues_finished.connect(_on_dialogue_finished)
		in_dialogue = true


func _on_dialogue_finished(_point):
	dialogue_character.current_state = States.DEFAULT
	in_dialogue = false


func on_enabled():
	self.current_state = States.DEFAULT


func on_disabled():
	pass

# This method will be overridden in derived classes to specify character-specific dialogues
func setup_dialogues():
	pass
	

func dialogue_area_entered(body):
	"""
	Triggers when another body (character) enters the dialogue interaction area, setting the state to READY_TO_DIALOGUE.
	"""
	if body is Main and body != self:
		print('In dialogue zone')
		current_state = BaseNPC.States.READY_TO_DIALOGUE
		
		dialogue_character = body
		
		if not dialogue_interact_created:
			dialogue_interact = load('res://prefabs/interface/dialogues/dialogue_interact.tscn').instantiate()
			add_child(dialogue_interact)
			dialogue_interact_created = true
			dialogue_interact.global_position = Vector2(self.global_position.x + 7,  self.global_position.y - 25)


func dialogue_area_exited(body):
	"""
	Reverts the state to DEFAULT when another character leaves the dialogue interaction area, indicating the end of potential for dialogue interaction.
	"""
	if body is Main and body != self:
		print('Out of dialogue zone')
		current_state = BaseNPC.States.DEFAULT
		
		if dialogue_interact_created:
			remove_child(dialogue_interact)
			dialogue_interact = null
			dialogue_interact_created = false
			
