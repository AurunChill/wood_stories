extends BaseCharacter
class_name Wizard

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogue_area: Area2D = $DialogueArea

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Base character methods
func on_default(delta):
	pass
		
func on_ready_to_dialogue():
	pass
	
func on_enabled():
	self.current_state = BaseCharacter.States.DEFAULT

func on_disabled():
	pass

# Extra methods
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


# Engine methods
func _ready():
	anim.play('idle')
	current_state = BaseCharacter.States.DEFAULT
	
func _physics_process(delta):
	_apply_gravity(delta)
	match current_state:
		BaseCharacter.States.DEFAULT:
			on_default(delta)
		BaseCharacter.States.READY_TO_DIALOGUE:
			on_ready_to_dialogue()
		BaseCharacter.States.ENABLED:
			on_enabled()
		BaseCharacter.States.DISABLED:
			on_disabled()


func _on_dialogue_area_body_entered(body):
	if body is BaseCharacter and body != self:
		print('In dialogue zone')
		current_state = BaseCharacter.States.READY_TO_DIALOGUE


func _on_dialogue_area_body_exited(body):
	if body is BaseCharacter and body != self:
		print('Out of dialogue zone')
		current_state = BaseCharacter.States.DEFAULT
		
