extends Node2D
class_name DialogueManager
## This class serves as a manager for dialog boxes, handling the queue and display of dialog data.

## Stores an array of dictionaries, each representing the data for a single dialogue.
var dialogue_queue: Array[Dialogue] = []
var current_dialogue: DialogueWindow = null 

## Defines a signal to indicate that all dialogues in the queue have been finished.
signal all_dialogues_finished


## Adds a dialogue's data into the dialogue_queue array for future display.
## @param dialogue_data Dictionary containing the necessary data to display a dialogue.
func add_to_queue(dialogue: Dialogue) -> void:
	dialogue_queue.append(dialogue)

## Initiates the sequence of displaying all dialogues stored in the dialogue_queue.
func start_dialogues():
	if not _is_queue_empty():
		_play_next()
		

## Proceeds to display the next dialogue in the queue by loading and showing the dialogue window.
## It pops the front item from the dialogue queue and initiates its display.
func _play_next():
	var data = dialogue_queue.pop_front()
	var dialogue_window = load("res://prefabs/interface/dialogues/dialogue_window.tscn").instantiate()
	current_dialogue = dialogue_window
	add_child(current_dialogue)
	current_dialogue.show_dialogue(data)
	current_dialogue.dialogue_finished.connect(_on_dialogue_finished)

## Checks if the dialogue queue is empty. If so, emits the 'all_dialogues_finished' signal.
## @return bool True if the queue is empty, false otherwise.
func _is_queue_empty() -> bool:
	if len(dialogue_queue) == 0:
		all_dialogues_finished.emit(null)
		return true
	return false

## Callback function called when a dialogue finishes displaying.
## It checks if there are more dialogues to display and continues the dialogue sequence if so.
func _on_dialogue_finished():
	if not _is_queue_empty():
		_play_next()
