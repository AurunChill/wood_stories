extends Control

@onready var loading_label = $CanvasLayer/text_wait/text_loading
@onready var loading_fact = $CanvasLayer/text_fact
@onready var loading_piggy = $CanvasLayer/PiggyLoading

var label_timer = 0.0
var label_dots_count = 1

var fact_timer = 0.0

var is_shown = false
var is_showing_piggy = false


func init_screen():
	is_shown = true
	_set_fact()
	
	
func deinit_screen():
	is_shown = false
	is_showing_piggy = false
	

func _start_loading_label(delta):
	label_timer += delta
	if label_timer >= 0.5:
		label_timer = 0  # Reset timer
		label_dots_count += 1
		if label_dots_count > 15:
			label_dots_count = 1  # Reset dot count
			loading_label.text = '.'
		loading_label.text += '.'


func _load_fact_from_file(index: int) -> String:
	"""
	Load a fact from a file at a specified index.

	:param index: Index of the fact to load from the file.
	:return: The loaded fact as a string.
	"""
	var file = FileAccess.open('res://extra/facts.txt', FileAccess.READ)
	
	var line_counter = 0
	while not file.eof_reached(): 
		if line_counter == index:
			return file.get_line()
		line_counter += 1
		file.get_line()
	return ''
	

func _set_fact():
	"""
	Randomly select and set a fact to be displayed on the label.
	"""
	var fact_index = randi() % 80
	var fact = _load_fact_from_file(fact_index)
	loading_fact.text = 'Рандомный факт: ' + fact.split('.')[1] # Removing leading number
	
	
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
	

func _on_right_animation_complete():
	_piggy_animate(false)
	

func _on_left_animation_complete():
	var delay = randf_range(7, 12) # Случайная задержка
	await get_tree().create_timer(delay).timeout
	_piggy_animate(true)
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	init_screen()
	

func _exit_tree():
	deinit_screen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_shown:
		_start_loading_label(delta)
		
		fact_timer += delta
		if fact_timer >= 8:
			_set_fact()
			fact_timer = 0  # Reset timer
			
		if not is_showing_piggy:
			is_showing_piggy = true
			var delay = randf_range(3, 5) # Случайная задержка
			await get_tree().create_timer(delay).timeout
			_piggy_animate(true)
