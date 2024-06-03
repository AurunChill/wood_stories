extends Node
class_name GameManager
## Controls scene 'script' flow

## A node representing the server, linked via the editor.
@onready var server: Server = $Server
## A node representing the translator, linked via the editor.
@onready var translator: Translator = $Translator
## Main node linked via the hierarchy.
@onready var main: Main = get_parent().get_node('main')
## HUD node linked via the hierarchy.
@onready var hud: HUD = get_parent().get_node('HUD')

## Various instance variables for state management.
var loading_screen: LoadScreen = null
var level_up_screen: LevelUpScreen = null
var request_amount: int

var data: Translator.ScriptData
var action_indexes: Dictionary = {'data_id': 0, 'id': 0, 'dialogue_id': 0}
var move_target: PointOfInterest = null
var current_prompt: String = ''
var actions_queue: Array = []

## Called when the node is ready.
func _ready():
	# Connect the input ended signal from HUD to the method _on_get_input_text.
	hud.connect('input_ended', _on_get_input_text)

## Sends a request to the server with the specified prompt.
##
## @param prompt: The prompt string to send to the server.
## @return: void
func _send_request(prompt: String):
	current_prompt = prompt
	server.send_request(prompt)
	
	# Show the loading screen while waiting for the server response.
	loading_screen = load('res://prefabs/interface/loading/load_screen.tscn').instantiate()
	add_child(loading_screen)
		
	move_target = _determine_move_target('start')
	if not move_target.has(main):
		main.move_point = move_target
		main.current_state = States.Character.MOVING_TO_POINT
		if not move_target.has_come.is_connected(_on_start_point):
			move_target.has_come.connect(_on_start_point)
	else:
		main.current_state = States.Character.DISABLED
	hud.disable()
		
	if not server.request_completed.is_connected(_on_request_completed):
		server.request_completed.connect(_on_request_completed, ConnectFlags.CONNECT_ONE_SHOT)

## Handles the event when the character reaches the start point.
##
## @param point: The point where the character moves to.
## @return: void
func _on_start_point(point: PointOfInterest):
	if main.move_point == point:
		main.current_state = States.Character.DISABLED

## Handles the server request completion event.
##
## @param response: The server's response to the request.
## @return: void
func _on_request_completed(response):
	remove_child(loading_screen)
	if not response:
		print('Invalid generation!')		
		var error_screen = load('res://prefabs/interface/loading/error_notification.tscn').instantiate()
		add_child(error_screen)
		main.current_state = States.Character.DEFAULT
		main.move_point = null
		hud.enable()
		return
		
	main.current_state = States.Character.DEFAULT
	hud.enable()
	
	data = translator.translate(response)
	_reset_action_indexes()
	_prepare_actions_queue()
	_process_actions_queue()

## Resets the action indexes to their initial state.
##
## @return: void
func _reset_action_indexes():
	action_indexes = {'data_id': 0, 'id': 0, 'dialogue_id': 0}
	move_target = null

## Prepares the actions queue by appending each action data.
##
## @return: void
func _prepare_actions_queue():
	actions_queue.clear()
	while _has_more_actions():
		var action_data = _get_current_action()
		actions_queue.append(action_data)
		_advance_action_pointer()

## Checks if there are more actions to be processed.
##
## @return: bool: True if more actions exist, otherwise false.
func _has_more_actions() -> bool:
	return action_indexes['data_id'] < data.actions.size()

## Processes the queued actions.
##
## @return: void
func _process_actions_queue():
	if actions_queue.size() == 0:
		print('All actions processed')
		_show_level_up_screen()
		return
	var action_data = actions_queue.pop_front()
	match action_data.method_name:
		'come_to':
			_handle_move_action(action_data)
		'begin_dialogue_to':
			_start_dialogue_sequence(action_data)

## Gets the current action based on the action indexes.
##
## @return: The current action data.
func _get_current_action():
	return data.actions[action_indexes['data_id']][action_indexes['id']]

## Handles the move action by determining the move target and initiating movement.
##
## @param action_data: The action data containing movement information.
## @return: void
func _handle_move_action(action_data: Translator.ActionData):
	move_target = _determine_move_target(action_data.role)
	if main.move_point != move_target:
		_initiate_move_to(move_target)
	else:
		_process_actions_queue()

## Starts the dialogue sequence based on action data.
##
## @param action_data: The action data containing dialogue information.
## @return: void
func _start_dialogue_sequence(action_data: Translator.ActionData):
	var dialogue_manager = DialogueManager.new()
	add_child(dialogue_manager)
	var current_dialogue_data = data.dialogues[action_indexes['dialogue_id']]
	for dialogue in current_dialogue_data:
		dialogue_manager.add_to_queue(dialogue)
	dialogue_manager.start_dialogues()
	dialogue_manager.all_dialogues_finished.connect(_on_action_finished)
	action_indexes['dialogue_id'] += 1

## Handles the event when an action is finished.
##
## @param point: The point where the action was completed.
## @return: void
func _on_action_finished(point: PointOfInterest):
	print('action is finished')
	if point == main.move_point:
		main.current_state = States.Character.DEFAULT
	_process_actions_queue()

## Gets input text and sends a request.
##
## @param prompt: The prompt text input by the user.
## @return: void
func _on_get_input_text(prompt: String):
	_send_request(prompt)

## Advances the action pointer to the next action.
##
## @return: void
func _advance_action_pointer():
	action_indexes['id'] += 1
	if action_indexes['id'] >= data.actions[action_indexes['data_id']].size():
		action_indexes['id'] = 0
		action_indexes['data_id'] += 1

## Determines the move target based on the title.
##
## @param title: The title to determine the move target.
## @return: Node: The determined move target node.
func _determine_move_target(title: String) -> Node:
	return get_parent().get_node('point_' + title.to_lower())

## Initiates movement to the specified target.
##
## @param target: The target PointOfInterest node to move to.
## @return: void
func _initiate_move_to(target: PointOfInterest):
	main.move_point = target
	main.current_state = States.Character.MOVING_TO_POINT
	if not target.has_come.is_connected(_on_action_finished):
		target.has_come.connect(_on_action_finished, ConnectFlags.CONNECT_ONE_SHOT)
		
## Shows the level up screen and handles the timing for hiding it.
##
## @return: void
func _show_level_up_screen():
	level_up_screen = load('res://prefabs/interface/level_up_screen.tscn').instantiate()
	add_child(level_up_screen)
	request_amount = Saver.load_total_request_amount() + 1	
	level_up_screen.set_amount(request_amount)
	
	var hide_timer = Timer.new()
	hide_timer.wait_time = 5
	hide_timer.one_shot = true
	add_child(hide_timer)
	hide_timer.start()
	hide_timer.timeout.connect(_on_hide_level_up_screen)

## Hides the level up screen after the timer times out.
##
## @return: void
func _on_hide_level_up_screen():
	remove_child(level_up_screen)
	level_up_screen = null
	Saver.save_total_request_amount(request_amount)
