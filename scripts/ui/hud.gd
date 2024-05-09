extends Node

@onready var text_input = $CanvasLayer/MarginContainer/LineEdit

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
		if child is Main:
			child.current_state = BaseNPC.States.DISABLED


func _on_line_edit_focus_exited():
	for child in get_parent().get_children():
		if child is Main:
			child.current_state = BaseNPC.States.ENABLED


func _on_line_edit_text_submitted(new_text):
	text_input.text = ''
	text_input.release_focus()
	input_ended.emit(new_text)


func _on_line_edit_mouse_exited():
	text_input.release_focus()
