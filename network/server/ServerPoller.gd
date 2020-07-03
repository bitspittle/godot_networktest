extends Node

class_name ServerPoller

var server: WebSocketServer

func _process(delta):
	if server.is_listening():
		server.poll()
