class_name Dialogue

var speaker_left
var speaker_right
var text
var is_left_active


func _init(speaker_left, speaker_right, text, is_left_active):
	self.speaker_left = speaker_left
	self.speaker_right = speaker_right
	self.text = text
	self.is_left_active = is_left_active
	
	
func _to_string() -> String:
	var speaker: String
	if is_left_active:
		speaker = self.speaker_left
	else:
		speaker = self.speaker_right
		
	return speaker + ': ' + self.text


class Roles:
	static var NONE = 'NONE'
	static var MAIN = 'MAIN'
	static var WIZARD = 'WIZARD'
	static var NECROMANCER = 'NECROMANCER'
	
	static func get_values() -> Array[String]:
		return [NONE, MAIN, WIZARD, NECROMANCER]
	
