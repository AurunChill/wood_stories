extends Control
class_name LevelUpScreen
## LevelUpText is a control node that modifies the text of a user level

## A label node in the scene linked via the editor.
## Automatically initialized when the scene is loaded.
@onready var request_amount_text: Label = $CanvasLayer/request_amount

## Sets the amount in the `request_amount_text` label.
## This takes an integer and appends it to the existing label text.
##
## @param amount: The integer amount to be appended to the `request_amount_text`.
## @return: void
func set_amount(amount: int):
	# Append the amount to the request_amount_text with a preceding space
	request_amount_text.text += ' ' + str(amount)
