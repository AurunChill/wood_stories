extends CanvasLayer
class_name HUD
## The HUD class extends CanvasLayer and represents a Head-Up Display for user interaction. 
## It consists of a text input field and a menu button, both linkable via the editor. 
## This class provides functionalities to enable and disable the HUD elements, 
## manage the focus of the text input field, handle text input submissions, and control the state of BaseCharacter nodes in the parent node based on the text input's focus state. 
## It emits a signal carrying the submitted prompt when text input is ended.


## The text input field in the scene, linked via the editor.
## Automatically initialized when the scene is loaded.
@onready var text_input: LineEdit = $MarginContainer/LineEdit


## The menu button in the scene, linked via the editor.
## Automatically initialized when the scene is loaded.
@onready var menu_button: MenuButton = $MenuButton


# Signal emitted when text input is ended, carrying the submitted prompt.
signal input_ended(prompt)


## Disables the current CanvasLayer and the text input field.
## Sets both nodes to be invisible.
##
## @return: void
func disable():
	self.visible = false
	text_input.visible = false
	

## Enables the current CanvasLayer and the text input field.
## Sets both nodes to be visible.
##
## @return: void
func enable():
	self.visible = true
	text_input.visible = true


## Called when the text input field gains focus.
## Disables all BaseCharacter nodes in the parent node by setting their state to DISABLED.
##
## @return: void
func _on_line_edit_focus_entered():
	for child in get_parent().get_children():
		if child is BaseCharacter:
			child.current_state = States.Character.DISABLED


## Called when the text input field loses focus.
## Resets all BaseCharacter nodes in the parent node by setting their state to DEFAULT.
##
## @return: void
func _on_line_edit_focus_exited():
	for child in get_parent().get_children():
		if child is BaseCharacter:
			child.current_state = States.Character.DEFAULT


## Called when text is submitted in the text input field.
## Emits the `input_ended` signal with the new text, clears the text input, and releases focus.
##
## @param new_text: The text that was submitted.
## @return: void
func _on_line_edit_text_submitted(new_text: String):
	text_input.text = ''
	text_input.release_focus()
	input_ended.emit(new_text)


## Called when the mouse cursor exits the text input field area.
## Releases focus from the text input field.
##
## @return: void
func _on_line_edit_mouse_exited():
	text_input.release_focus()
