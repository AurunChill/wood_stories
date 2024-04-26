extends Node

const HOST = 'localhost'
const PORT = '5051'
const METHOD = 'send_prompt'

signal request_completed(response)

func send_request(prompt: String) -> void:
	print('Sending prompt')
	var url = 'http://' + HOST + ':' + PORT + '/' + METHOD
	var headers = ['Content-Type: application/json']
	var json = JSON.stringify({'prompt': prompt})
	
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print('Response code: ' + str(response_code))
	var response = null
	if response_code == 200:
		response = JSON.parse_string(body.get_string_from_utf8())
		print("Successful response!")
		print(response)
		request_completed.emit(response)
		return
	print("Request failed with code:", response_code)
	request_completed.emit(response)
