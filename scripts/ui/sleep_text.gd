extends Control
class_name SleepText
## SleepText is a control node that modifies the text of a label over time to simulate a sleeping motion.
##
## This class provides the functionality to animate a "sleep" text by repeatedly adding 'Z ' characters
## up to a certain limit and then resetting.


## A label node in the scene linked via the editor.
## Automatically initialized when the scene is loaded.
@onready var sleep_label: Label = $sleep_text 


## The timer variable controlling the `sleep_label` animation interval.
## This is a float value representing the time in seconds.
var timer: float = 2.0


## Called when the node is added to the scene.
## Sets the node to process every frame.
func _ready() -> void:
	set_process(true)


## Called every frame with the time elapsed since the previous frame.
## Modifies the `sleep_label` text based on the timer.
##
## @param delta: The time elapsed since the last frame in seconds.
## @return: void
func _process(delta: float) -> void:
	# If the timer has reached or exceeded 2 seconds
	if timer >= 2.0:
		# If the text in the sleep_label is shorter than 10 characters
		if len(sleep_label.text) < 10:
			# Append 'Z ' to the sleep_label text to simulate snoring
			sleep_label.text += 'Z '
		else:
			# If the sleep_label text is too long, reset it to a single space
			sleep_label.text = ' '
		# Reset the timer to start counting 2 seconds again
		timer = 0.0
	else:
		# Increment the timer by the time elapsed since the last frame
		timer += delta

