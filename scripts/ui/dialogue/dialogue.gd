class_name Dialogue

## Dialogue is a class that encapsulates a conversation dialogue with a speaker and text.
## It manages which speaker is currently active and contains methods to initialize and convert dialogue to a string.

## The left-side speaker in the dialogue.
var speaker_left


## The right-side speaker in the dialogue.
var speaker_right

## The text of the dialogue.
var text

## A boolean indicating if the left-side speaker is active.
var is_left_active


## Initializes a new instance of the Dialogue class.
## This constructor takes the speaker names, text for the dialogue, and a boolean indicating the active speaker.
##
## @param speaker_left: The name of the left-side speaker.
## @param speaker_right: The name of the right-side speaker.
## @param text: The dialogue text.
## @param is_left_active: A boolean indicating whether the left-side speaker is active.
func _init(speaker_left, speaker_right, text, is_left_active):
	# Assign parameters to instance variables
	self.speaker_left = speaker_left
	self.speaker_right = speaker_right
	self.text = text
	self.is_left_active = is_left_active


## Converts the dialogue to a formatted string.
## This method returns a string representation of the dialogue in the format "Speaker: Text".
##
## @return: A formatted string representation of the dialogue.
func _to_string() -> String:
	var speaker: String
	
	# Determine the active speaker based on the boolean flag
	if is_left_active:
		speaker = self.speaker_left
	else:
		speaker = self.speaker_right
		
	# Return the formatted string with the active speaker and text
	return speaker + ': ' + self.text


## Roles is a static class that defines various character roles which can be used in dialogues.
class Roles:
	## The role representing no specific assignment.
	static var NONE = 'NONE'
	## The role representing the main character.
	static var MAIN = 'MAIN'
	## The role representing a wizard character.
	static var WIZARD = 'WIZARD'
	## The role representing a necromancer character.
	static var NECROMANCER = 'NECROMANCER'
	## The role representing a knight character.
	static var KNIGHT = 'KNIGHT'
	
	## Gets the list of all defined roles.
	## This static method returns an array of strings representing all the roles.
	##
	## @return: An array of strings containing all the roles.
	static func get_values() -> Array[String]:
		return [NONE, MAIN, WIZARD, NECROMANCER, KNIGHT]
