extends CanvasLayer

@onready var text_input = $MarginContainer/LineEdit
@onready var menu_button = $MenuButton

# Signal
signal input_ended(prompt)

func disable():
	self.visible = false
	text_input.visible = false
	

func enable():
	self.visible = true
	text_input.visible = true


func _on_line_edit_focus_entered():
	for child in get_parent().get_children():
		if child is BaseCharacter:
			child.current_state = States.Character.DISABLED


func _on_line_edit_focus_exited():
	for child in get_parent().get_children():
		if child is BaseCharacter:
			child.current_state = States.Character.DEFAULT


func _on_line_edit_text_submitted(new_text):
	text_input.text = ''
	text_input.release_focus()
	input_ended.emit(new_text)


func _on_line_edit_mouse_exited():
	text_input.release_focus()
