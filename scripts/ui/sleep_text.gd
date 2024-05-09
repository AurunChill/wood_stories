extends Control
class_name SleepText

@onready var sleep_label: Label = $sleep_text
var timer: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer >= 2.0:
		if len(sleep_label.text) < 10:
			sleep_label.text += 'Z '
		else:
			sleep_label.text =  ' '
		timer = 0.0
	else:
		timer += delta
