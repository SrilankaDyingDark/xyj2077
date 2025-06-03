extends Control
@onready var create_dialog: HTTPRequest = $CreateDialog
@onready var ask_question: HTTPRequest = $AskQuestion


func _ready() -> void:
	pass # Replace with function body.

# 发起对话请求
func create():
	
	# 调用API发起建立对话的请求
	create_dialog.request(url, headers, HTTPClient.METHOD_POST, body)
