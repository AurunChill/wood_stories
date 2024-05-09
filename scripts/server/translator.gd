extends Node
class_name Translator

signal invalid_generation

class ScriptData:
	var actions
	var dialogues
	
	func _init(actions, dialogues):
		self.actions = actions
		self.dialogues = dialogues

class ActionData:
	var method_name
	var role
	
	func _init(method_name: String, role: String):
		self.method_name = method_name
		self.role = role
		
	func _to_string() -> String:
		return self.method_name + ' ' + self.role
		

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
	
	
func _get_action_info(action: String) -> ActionData:
	var action_method = action.split('(')[0]
	var action_role = action.split('(')[1].split(')')[0]
	for role in Dialogue.Roles.get_values():
		if role == action_role:
			return ActionData.new(action_method, role)	
	return ActionData.new(action_method, Dialogue.Roles.MAIN)	


func _find_speaker(actions: Array) -> String:
	for action in actions:
		var action_object = action.split('(')[1].split(')')[0]
		for value in Dialogue.Roles.get_values():
			if value == action_object and value != Dialogue.Roles.MAIN:
				return value 
	return Dialogue.Roles.NONE
	

func _get_dialogue_info(dialogue: Dictionary, speaker_right) -> Dialogue:
	var is_left_active = true
	if dialogue.speaker != Dialogue.Roles.MAIN:
		is_left_active = false
				
	return Dialogue.new(Dialogue.Roles.MAIN, speaker_right, dialogue.text, is_left_active)
	
	
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
