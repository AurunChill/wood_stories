extends Node

const HOST = 'localhost'
const PORT = '5051'
const METHOD = 'send_prompt'

signal request_completed(response)

func send_request(prompt: String) -> void:
	"""
	Send a request to a specified URL with the provided prompt.
	
	:param prompt: The prompt string to be sent.
	"""
	print('Sending prompt')
	var url = 'http://' + HOST + ':' + PORT + '/' + METHOD
	var headers = ['Content-Type: application/json']
	var json = JSON.stringify({'prompt': prompt + '. Minimum 12 dialogues!!'})
	
	if not $HTTPRequest.request_completed.is_connected(_on_request_completed):
		$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	"""
	Handle the completion of the HTTP request.
	
	:param result: The result of the request.
	:param response_code: The HTTP response code.
	:param headers: An array containing the response headers.
	:param body: The response body as a byte array.
	"""
	print('Response code: ' + str(response_code))
	var response = null
	if response_code == 200:
		response = JSON.parse_string(body.get_string_from_utf8())
		print("Successful response!")
		request_completed.emit(response)
		return
	print("Request failed with code:", response_code)
	request_completed.emit(response)
