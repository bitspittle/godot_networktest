extends SceneTree

const PORT_ENV_VAR = "GODOT_PORT"

var _server: WebSocketServer = null
var _clients = {}

func _init():
	var port_str = OS.get_environment(PORT_ENV_VAR)
	var port = 0
	if port_str != null && port_str != "":
		print("Found \"", PORT_ENV_VAR, "\": ", port_str)
		port = port_str.to_int()

	if port == 0 || port > 65535:
		print("Environment variable \"", PORT_ENV_VAR, "\" not set or invalid. Randomizing...")
		randomize()
		port = int(rand_range(1, 65535))

	print("Listening on port: ", port)

	connect("network_peer_connected", self, "_peer_connected")
	connect("network_peer_disconnected", self, "_peer_disconnected")

	_server = WebSocketServer.new()
	_server.listen(port, PoolStringArray(), true)
	set_network_peer(_server)


	var poller = ServerPoller.new()
	poller.server = _server
	get_root().add_child(poller)

func _peer_connected(id):
	_clients[id] = null

func _peer_disconnected(id):
	_clients.erase(id)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		for id in _clients.keys():
			_server.disconnect_peer(id)
