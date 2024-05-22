class_name Saver
## Response for saving/fetching values to/from files

## Saves the total request amount to a file.
## This function opens a file in write mode and stores the given integer value.
##
## @param value: The integer amount to be stored in the file.
## @return: void
static func save_total_request_amount(value: int) -> void:
	var file = FileAccess.open('user://save_data.sav', FileAccess.WRITE)
	file.store_var(value)
	file.close()

## Loads the total request amount from a file.
## This function checks if the file exists, opens it in read mode, and retrieves the integer value stored in the file.
##
## @return: An integer representing the total request amount stored in the file. Returns 0 if the file does not exist.
static func load_total_request_amount() -> int:
	if FileAccess.file_exists('user://save_data.sav'):
		var file = FileAccess.open('user://save_data.sav', FileAccess.READ)		
		var value: int = file.get_var()
		return value
	return 0
