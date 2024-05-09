extends Node

@onready var server: Node = $Server
@onready var translator: Node = $Translator
@onready var main: Main = get_parent().get_node('main')
@onready var hud: Node = get_parent().get_node('HUD')

var loading_screen = null

var data
var action_indexes = {"data_id": 0, "id": 0, "dialogue_id": 0}
var move_target = null
var current_prompt = ''
var actions_queue = [] # Queue to store actions

func _ready():
	hud.connect("input_ended", _on_get_input_text)


func _send_request(prompt: String):
	#current_prompt = prompt
	#server.send_request(prompt)
	#
	#loading_screen = load("res://prefabs/interface/loading/load_screen.tscn").instantiate()
	#add_child(loading_screen)
		#
	#move_target = _determine_move_target('start')
	#if not move_target.is_in(main):
		#main.move_point = move_target
		#main.current_state = BaseNPC.States.MOVING_TO_POINT
		#if not move_target.has_come.is_connected(_on_start_point):
			#move_target.has_come.connect(_on_start_point)
	#else:
		#main.current_state = BaseNPC.States.DISABLED
	#hud.disable()
		
	_on_request_completed('some')
	#if not server.request_completed.is_connected(_on_request_completed):
		#server.request_completed.connect(_on_request_completed, ConnectFlags.CONNECT_ONE_SHOT)


func _on_start_point(point):
	if main.move_point == point:
		main.currenta_state = States.Character.DISABLED


func _on_request_completed(response):
	#remove_child(loading_screen)
	if not response:
		print('Invalid generation!')		
		var error_screen = load('res://prefabs/interface/loading/error_notification.tscn').instantiate()
		add_child(error_screen)
		main.current_state = States.Character.DEFAULT
		main.move_point = null
		hud.enable()
		return
		
	response = {
	"script": [
			{
				"actions": [
					"come_to(WIZARD)",
					"begin_dialogue_to(WIZARD)"
				],
				"dialogue": [
					{
						"speaker": "MAIN",
						"text": "Greetings, Wise Wizard! I seek your guidance."
					},
					{
						"speaker": "WIZARD",
						"text": "Welcome, adventurer. How may I assist you?"
					},
					{
						"speaker": "MAIN",
						"text": "I have heard rumors of a strange necromancer lurking in the forest. Do you know anything about this?"
					},
					{
						"speaker": "WIZARD",
						"text": "Ah, yes. The necromancer is a dangerous figure, using dark magic for forbidden purposes. Be cautious on your quest."
					},
					{
						"speaker": "MAIN",
						"text": "Thank you for the warning, Wizard. I will proceed with caution."
					}
				]
			},
			{
				"actions": [
					"come_to(NECROMANCER)",
					"begin_dialogue_to(NECROMANCER)"
				],
				"dialogue": [
					{
						"speaker": "MAIN",
						"text": "Greetings, Necromancer. I come seeking answers about your dark ways."
					},
					{
						"speaker": "NECROMANCER",
						"text": "Why do you disturb me, mortal?"
					},
					{
						"speaker": "MAIN",
						"text": "I wish to understand your motives and intentions. Why do you practice necromancy?"
					},
					{
						"speaker": "NECROMANCER",
						"text": "My power is not for the weak-minded to comprehend. Leave now, before it is too late."
					},
					{
						"speaker": "MAIN",
						"text": "I will not leave until I have the answers I seek. Tell me, Necromancer, what drives you to darkness?"
					}
				]
			}
		]
	}
	main.current_state = States.Character.DEFAULT
	hud.enable()
	
	data = translator.translate(response)
	_reset_action_indexes()
	_prepare_actions_queue()
	_process_actions_queue()


func _reset_action_indexes():
	action_indexes = {"data_id": 0, "id": 0, "dialogue_id": 0}
	move_target = null


func _prepare_actions_queue():
	actions_queue.clear() # Clear the queue before filling
	while _has_more_actions():
		var action_data = _get_current_action()
		actions_queue.append(action_data) # Enqueue the action
		_advance_action_pointer()

func _has_more_actions() -> bool:
	return action_indexes["data_id"] < data.actions.size()

func _process_actions_queue():
	if actions_queue.size() == 0:
		print("All actions processed")
		return
	var action_data = actions_queue.pop_front() # Dequeue the next action
	match action_data.method_name:
		'come_to':
			_handle_move_action(action_data)
		'begin_dialogue_to':
			print('here')
			_start_dialogue_sequence(action_data)
			# Note: We cannot immediately process the next action in queue here
			# as dialogues are asynchronous. It will be triggered by _on_action_finished.


func _get_current_action():
	return data.actions[action_indexes["data_id"]][action_indexes["id"]]


func _handle_move_action(action_data):
	move_target = _determine_move_target(action_data.role)
	if main.move_point != move_target:
		_initiate_move_to(move_target)
	else:
		_process_actions_queue() # Directly process next action if no movement needed


func _start_dialogue_sequence(action_data):
	var dialogue_manager = DialogueManager.new()
	add_child(dialogue_manager)
	var current_dialogue_data = data.dialogues[action_indexes["dialogue_id"]]
	for dialogue in current_dialogue_data:
		dialogue_manager.add_to_queue(dialogue)
	dialogue_manager.start_dialogues()
	dialogue_manager.all_dialogues_finished.connect(_on_action_finished)
	action_indexes["dialogue_id"] += 1


func _on_action_finished(point):
	print('action is finished')
	if point == main.move_point:
		main.current_state = States.Character.DEFAULT
	_process_actions_queue()


func _on_get_input_text(prompt: String):
	_send_request(prompt)


func _advance_action_pointer():
	action_indexes["id"] += 1
	if action_indexes["id"] >= data.actions[action_indexes["data_id"]].size():
		action_indexes["id"] = 0
		action_indexes["data_id"] += 1


func _determine_move_target(title) -> Node:
	return get_parent().get_node("point_" + title.to_lower())


func _initiate_move_to(target: PointOfInterest):
	main.move_point = target
	main.current_state = States.Character.MOVING_TO_POINT
	if not target.has_come.is_connected(_on_action_finished):
		target.has_come.connect(_on_action_finished, ConnectFlags.CONNECT_ONE_SHOT)
