extends Control
class_name LoadScreen
## Managing load screen

## A label node that displays loading text.
## Automatically initialized when the scene is loaded.
@onready var loading_label = $CanvasLayer/text_wait/text_loading

## A label node that displays random facts.
## Automatically initialized when the scene is loaded.
@onready var loading_fact = $CanvasLayer/text_fact

## A sprite node for displaying piggy animation.
## Automatically initialized when the scene is loaded.
@onready var loading_piggy = $CanvasLayer/PiggyLoading

## Timer for managing loading label dots animation.
var label_timer = 0.0

## Counter for the number of dots in loading label text.
var label_dots_count = 1

## Timer for managing how often facts change.
var fact_timer = 0.0

## Flag to indicate if the screen is currently shown.
var is_shown = false

## Flag to indicate if the piggy animation is currently showing.
var is_showing_piggy = false


## Initializes the loading screen, setting it to shown state and sets the initial fact.
## @return: void
func init_screen():
	is_shown = true
	_set_fact()


## De-initializes the loading screen, setting it to hidden state.
## @return: void
func deinit_screen():
	is_shown = false
	is_showing_piggy = false


## Starts the loading label animation by adding dots in periodic intervals.
## @param delta: The time elapsed since the last frame.
## @return: void
func _start_loading_label(delta):
	label_timer += delta
	if label_timer >= 0.5:
		label_timer = 0
		label_dots_count += 1
		if label_dots_count > 15:
			label_dots_count = 1
			loading_label.text = '.'
		loading_label.text += '.'


## Loads a fact from the file based on the provided index.
## @param index: The index of the fact to load from the file.
## @return: String: The fact text.
func _load_fact_from_file(index: int) -> String:
	var file = FileAccess.open('res://extra/facts.txt', FileAccess.READ)
	var line_counter = 0
	while not file.eof_reached(): 
		if line_counter == index:
			return file.get_line()
		line_counter += 1
		file.get_line()
	return ''


## Sets a random fact in the loading_fact label.
## @return: void
func _set_fact():
	var fact_index = randi() % 80
	var fact = _load_fact_from_file(fact_index)
	loading_fact.text = 'Рандомный факт: ' + fact.split('.')[1]


## Animates the piggy by moving it either to the right or left.
## @param is_positive: Determines if the piggy should move to the right (True) or left (False).
## @return: void
func _piggy_animate(is_positive: bool):
	if not is_shown:
		is_showing_piggy = false
		return
		
	var tween = create_tween()
	var new_position = 0
	var duration = 0
	var method = null
	if is_positive:
		new_position = loading_piggy.position.x + 165
		duration = 0.1
		method = _on_right_animation_complete
	else:
		new_position = loading_piggy.position.x - 165
		duration = 3
		method = _on_left_animation_complete
	if tween != null:
		tween.tween_property(loading_piggy, 'position:x', new_position, duration)
		tween.finished.connect(method)


## Callback function when right animation completes.
## @return: void
func _on_right_animation_complete():
	_piggy_animate(false)


## Callback function when left animation completes and starts a new animation after a delay.
## @return: void
func _on_left_animation_complete():
	var delay = randf_range(7, 12)
	await get_tree().create_timer(delay).timeout
	_piggy_animate(true)


## Called when the node is added to the scene. Initializes the screen.
## @return: void
func _ready():
	init_screen()


## Called when the node is removed from the scene tree. Deinitializes the screen.
## @return: void
func _exit_tree():
	deinit_screen()


## Called every frame. Updates the loading label, fact, and piggy animations based on timers.
## @param delta: The time elapsed since the last frame.
## @return: void
func _process(delta):
	if is_shown:
		_start_loading_label(delta)
		
		fact_timer += delta
		if fact_timer >= 8:
			_set_fact()
			fact_timer = 0
			
		if not is_showing_piggy:
			is_showing_piggy = true
			var delay = randf_range(3, 5)
			await get_tree().create_timer(delay).timeout
			_piggy_animate(true)
