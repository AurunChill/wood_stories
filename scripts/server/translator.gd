extends Node
class_name Translator
## Converts server responses to objects

## Signal emitted when the generation is invalid.
signal invalid_generation

## Class to hold script data which includes actions and dialogues.
class ScriptData:
	var actions: Array
	var dialogues: Array
	
	## Initialize the ScriptData with actions and dialogues.
	##
	## @param actions: The list of actions.
	## @param dialogues: The list of dialogues.
	func _init(actions: Array, dialogues: Array):
		self.actions = actions
		self.dialogues = dialogues

## Class to hold individual action data including method name and role.
class ActionData:
	var method_name: String
	var role: String
	
	## Initialize the ActionData with the method name and role.
	##
	## @param method_name: The name of the method.
	## @param role: The role associated with the action.
	func _init(method_name: String, role: String):
		self.method_name = method_name
		self.role = role
		
	## Convert the action data to string representation.
	##
	## @return: A string representation of the method name and role.
	func _to_string() -> String:
		return self.method_name + ' ' + self.role
		

## Translates the response data into ScriptData.
##
## @param response: The response containing the script data.
## @return: The ScriptData containing actions and dialogues.
func translate(response) -> ScriptData:
	if response.has('detail'):
		invalid_generation.emit()
		return null
		
	var scripts = response.script
	var result_dialogues = []
	var result_actions = []
	
	for script in scripts:
		var actions: Array[ActionData] = []
		for action in script.actions:
			actions.append(_get_action_info(action))
		result_actions.append(actions)
		
		var speaker_left: String = Dialogue.Roles.MAIN
		var speaker_right: String = _find_speaker(script.actions)
		
		var dialogues: Array[Dialogue] = []
		for dialogue in script.dialogue:
			dialogues.append(_get_dialogue_info(dialogue, speaker_right))
		result_dialogues.append(dialogues)
			
	var result: ScriptData = ScriptData.new(result_actions, result_dialogues)
	_show_info(result)
	return result
	
	
## Retrieves action information based on the provided action string.
##
## @param action: The action string to parse.
## @return: An ActionData object based on the parsed action.
func _get_action_info(action: String) -> ActionData:
	var action_method = action.split('(')[0]
	var action_role = action.split('(')[1].split(')')[0]
	for role in Dialogue.Roles.get_values():
		if role == action_role:
			return ActionData.new(action_method, role)	
	return ActionData.new(action_method, Dialogue.Roles.MAIN)	


## Finds and returns the speaker role from the provided actions.
##
## @param actions: The list of actions to analyze.
## @return: The role of the speaker. If no specific role is found, returns Dialogue.Roles.NONE.
func _find_speaker(actions: Array) -> String:
	for action in actions:
		var action_object = action.split('(')[1].split(')')[0]
		for value in Dialogue.Roles.get_values():
			if value == action_object and value != Dialogue.Roles.MAIN:
				return value 
	return Dialogue.Roles.NONE
	

## Retrieves dialogue information based on the provided dialogue dictionary.
##
## @param dialogue: The dictionary containing dialogue data.
## @param speaker_right: The right speaker role.
## @return: A Dialogue object based on the parsed dialogue data.
func _get_dialogue_info(dialogue: Dictionary, speaker_right) -> Dialogue:
	var is_left_active = true
	if dialogue.speaker != Dialogue.Roles.MAIN:
		is_left_active = false
				
	return Dialogue.new(Dialogue.Roles.MAIN, speaker_right, dialogue.text, is_left_active)
	
	
## Prints the translated script data to the console.
##
## @param data: The ScriptData object containing actions and dialogues.
func _show_info(data: ScriptData) -> void:
	print('Translated data:')
	print('Actions:')
	for i in range(1, len(data.actions) + 1):
		print(str(i) + '. ' + str(data.actions[i - 1]))
		print()
	print()
	print()
	print('Dialogues')
	for i in range(1, len(data.dialogues) + 1):
		print(str(i) + '. ' + str(data.dialogues[i - 1]))
		print()
