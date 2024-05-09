class_name Saver

static func save_total_request_amount(value: int) -> void:
	var file = FileAccess.open('user://save_data.sav', FileAccess.WRITE)
	file.store_var(value)
	file.close()


static func load_total_request_amount() -> int:
	if FileAccess.file_exists('user://save_data.sav'):
		var file = FileAccess.open('user://save_data.sav', FileAccess.READ)		
		var value: int = file.get_var()
		return value
	return 0
