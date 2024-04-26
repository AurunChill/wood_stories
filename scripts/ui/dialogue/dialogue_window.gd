extends CanvasLayer
## Script handles the display of dialogue text with a typing effect, along with speaker icons for left and right sides

## Defines the rate at which characters in the dialogue text are revealed.
const CHAR_READ_RATE = 0.05
## Defines the waiting time before hiding the dialog, when all the text will be displayed
const END_WAIT_TIME = 1.0
## Transparency value for inactive speakers to distinguish between active and inactive speakers.
const INACTIVE_SPEAKER_TRANSPARENCY = 0.4

## Holds the container node for the textbox.
@onready var textbox_container = $TextboxContainer

## References to the symbols indicating the start of dialogue text.
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/start
## References to the symbols indicating the end of dialogue text.
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/end

## Reference to the label node where dialogue text is displayed.
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

## References to the speaker nodes on the left.
@onready var speaker_left = $speaker_left
## References to the speaker nodes on the right.
@onready var speaker_right = $speaker_right


## Enum to determine the side of the speaker in the dialogue.
enum SpeakerSides {
	LEFT,  ## Indicates the speaker is on the left side.
	RIGHT  ## Indicates the speaker is on the right side.
}

## Signal emitted when the dialogue has finished displaying.
signal dialogue_finished

## Preloads the constants script for access to global constants.
var constants = preload("res://scripts/global/constants.gd").new()


## Removes the dialogue display, including speakers, text, and the textbox itself.
func remove_dialogue() -> void:
	_remove_speakers()
	_remove_text()
	_remove_textbox()
	emit_signal("dialogue_finished")

## Prepares and shows the dialogue by configuring speakers and text display.
## @param speaker_left Path for the left speaker's texture.
## @param speaker_right Path for the right speaker's texture.
## @param text The dialogue text to display.
## @param is_left_active Boolean indicating if the left speaker is active.
func show_dialogue(speaker_left, speaker_right, text: String, is_left_active: bool = true) -> void:
	_show_textbox()
	
	if is_left_active:
		_show_speaker(speaker_left, SpeakerSides.LEFT, true)
		_show_speaker(speaker_right, SpeakerSides.RIGHT, false)
	else:
		_show_speaker(speaker_left, SpeakerSides.LEFT, false)
		_show_speaker(speaker_right, SpeakerSides.RIGHT, true)
		
	_show_text(text)

## Hides the speaker icons.
func _remove_speakers() -> void:
	speaker_left.hide()
	speaker_right.hide()

## Clears the dialogue text and symbols.
func _remove_text() -> void:
	label.visible_characters = 0
	start_symbol.text = ''
	end_symbol.text = ''
	label.text = ''

## Hides the textbox container.
func _remove_textbox() -> void:
	textbox_container.hide()


## Shows the specified speaker's icon and sets its active state.
## @param role Identifier for the speaker's role, used to load the correct sprite.
## @param side The side (LEFT or RIGHT) where the speaker's icon should be placed.
## @param is_active Boolean indicating if the speaker is actively speaking.
func _show_speaker(role, side: SpeakerSides, is_active: bool = true) -> void:
	var sprite = null
	
	# If there https request then role is float, that's why we translate it to enum
	if role is float or role is int:
		role = constants.int_to_role(role)
	
	match role:
		constants.Roles.MAIN:
			sprite = load("res://assets/characters/main/main_dialogue.png")
		constants.Roles.WIZARD:
			sprite = load("res://assets/characters/wizard/wizard_dialogue.png")
		_:
			print('default')
			sprite = null
	
	var current_speaker = null
	match side:
		SpeakerSides.LEFT:
			speaker_left.texture = sprite
			current_speaker = speaker_left
		SpeakerSides.RIGHT:
			current_speaker = speaker_right
			speaker_right.texture = sprite
	
	current_speaker.show()	
	if not is_active:
		current_speaker.modulate.a = INACTIVE_SPEAKER_TRANSPARENCY

## Begins the process of showing the dialogue text with a typing effect.
## @param text The dialogue text to display.
func _show_text(text: String) -> void:
	start_symbol.text = '*'
	label.text = text
	
	var tween = create_tween()
	tween.tween_property(label, 'visible_characters', len(text), CHAR_READ_RATE * len(text))
	tween.connect('finished', _on_text_tween_finished)

## Signifies the end of the text reveal and triggers a close timer.
func _on_text_tween_finished():
	end_symbol.text = 'v'
	_start_close_timer()

## Starts a timer for automatically closing the dialogue box after a brief pause.
func _start_close_timer():
	var timer = Timer.new()
	timer.wait_time = END_WAIT_TIME
	timer.one_shot = true
	timer.connect("timeout", _on_close_timer_timeout)
	add_child(timer)
	timer.start()

## Callback for the timer's timeout signal. Removes the dialogue display.
func _on_close_timer_timeout():
	remove_dialogue()

## Displays the textbox container.
func _show_textbox() -> void:
	textbox_container.show()

## Prepares the dialogue UI by clearing any existing dialogue on ready.
func _ready():
	remove_dialogue()
