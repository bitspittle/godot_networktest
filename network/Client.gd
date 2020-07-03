extends Node

var _client: WebSocketClient = null

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_success")
	get_tree().connect("connection_failed", self, "_connected_failure")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func connect_to_server(ip: String, port: int) -> void:
	print("Connecting to ", ip, ":", port, "...")

	_client = WebSocketClient.new();

	var url = "ws://" + ip + ":" + str(port)
	var error = _client.connect_to_url(url, PoolStringArray(), true);

	get_tree().set_network_peer(_client)

func _process(delta):
	if _client == null:
		return

	if _client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED \
	|| _client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING:
		_client.poll()


func _connected_success():
	print("Connection successful")

func _connected_failure():
	print("Connection rejected")

func _server_disconnected():
    print("Server disconnected")
