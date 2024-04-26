extends Node

var hud: Node

@onready var server = $Server

func move_character_to_coordinate(character: BaseCharacter, x_coord: float) -> void:
	var action = null
	if x_coord > character.position.x:
		action = 'right'
	else:
		action = 'left'
	
	Input.action_press(action)	
			
		

func _send_request(prompt: String):
	move_character_to_coordinate(get_parent().get_node('main'), int(prompt))
	#server.send_request(prompt)
	#server.request_completed.connect(_on_request_completed)

func _on_request_completed(response):
	print(response)
	
func _find_input():
	hud = get_parent().get_node('HUD')

func _ready():
	_find_input()
	hud.input_ended.connect(_on_get_input_text)
	

func _on_get_input_text(prompt: String):
	_send_request(prompt)

