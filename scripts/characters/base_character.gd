extends CharacterBody2D
class_name BaseCharacter

# State
enum States {
	DEFAULT,
	ENABLED,
	DISABLED,
	READY_TO_DIALOGUE
}
var current_state: States = States.DEFAULT

func on_default(delta):
	pass
	
func on_ready_to_dialogue():
	pass
	
func on_enabled():
	pass

func on_disabled():
	pass
