extends Control

@onready var request_amount_text: Label = $CanvasLayer/request_amount

func set_amount(amount: int):
	request_amount_text.text += ' ' + str(amount)
