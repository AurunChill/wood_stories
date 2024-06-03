extends Node
class_name Server
## Sends request to server and returns response

## Constants for server configuration
const HOST: String = 'localhost'
const PORT: String = '5051'
const METHOD: String = 'send_prompt'

## Signal emitted when the request is completed.
signal request_completed(response)

## Sends an HTTP request with the given prompt.
## 
## This function constructs the URL, headers, and JSON payload for the HTTP request,
## and then sends the request using the HTTPRequest node. It also connects the
## request_completed signal to the _on_request_completed function if not already connected.
##
## @param prompt: The string prompt to be sent in the request.
## @return: void
func send_request(prompt: String) -> void:
	print('Sending prompt')
	var url = 'http://' + HOST + ':' + PORT + '/' + METHOD
	var headers = ['Content-Type: application/json']
	var json = JSON.stringify({'prompt': prompt})
	
	# Ensure the request_completed signal is connected to the handler
	if not $HTTPRequest.request_completed.is_connected(_on_request_completed):
		$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)


## Handles the completion of the HTTP request.
##
## This function is connected to the request_completed signal of the HTTPRequest node.
## It prints the response code, parses the response body if the response code is 200,
## and emits the request_completed signal with the parsed response.
##
## @param result: The result of the HTTPRequest.
## @param response_code: The HTTP response code.
## @param headers: The response headers as a PackedStringArray.
## @param body: The response body as a PackedByteArray.
## @return: void
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print('Response code: ' + str(response_code))
	var response = null
	if response_code == 200:
		response = JSON.parse_string(body.get_string_from_utf8())
		print("Successful response!")
		request_completed.emit(response)
		return
	print("Request failed with code:", response_code)
	request_completed.emit(response)
